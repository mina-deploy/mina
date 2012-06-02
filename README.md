Van Helsing
===========

Really fast deployer and server automation tool.

Van Helsing works really fast because it's a deploy Bash script generator. It
generates an entire procedure as a Bash script and runs it remotely in the
server.

Compare this to the likes of Vlad or Capistrano, where each command
is ran separately on their own SSH sessions. Van Helsing only creates *one* SSH.
session per deploy, minimizing the SSH connection overhead.

How to test
-----------

It's not out on Rubygems right now but you can install it now:

    # Install the gem yourself
    $ git clone https://github.com/nadarei/van_helsing.git
    $ cd van_helsing
    $ gem build *.gemspec
    $ gem install *.gem

To test out stuff in development:

    # Run specs
    $ spec

    # Try out the test environment
    $ cd test_env
    $ ../bin/vh deploy simulate=1
    $ ../bin/vh deploy

Setting up
----------

### 1. Create a config/deploy.rb

In your project, type `vh init` to create a sample of this file.

This is just a Rake file with tasks!

    $ vh init
    Created config/deploy.rb.

See [About deploy.rb](#about-deployrb) for more info on what *deploy.rb* is.

### 2. Set up your server

Make a directory in your server called `/var/www/flipstack.com` (in *deploy_to*)
change it's ownership to the correct user.

    # SSH into your server, then:
    $ mkdir /var/www/flipstack.com
    $ chown -R username /var/www/flipstack.com

    # Make sure 'username' is the same as what's on deploy.rb

### 3. Run 'vh setup'

Now do `vh setup` to set up the [folder structure](#directory-structure) in this
path. This will connect to your server via SSH and create the right directories.

    $ vh setup
    -----> Creating folders... done.

See [directory structure](#directory-structure) for more info.

### 4. Deploy!

Use `vh deploy` to run the `deploy` task defined in *config/deploy.rb*.

    $ vh deploy
    -----> Deploying to 2012-06-12-040248
           ...
           Lots of things happening...
           ...
    -----> Done.

About deploy.rb
---------------

The file `deploy.rb` is simply a Rakefile invoked by Rake. In fact, `vh` is
mostly an alias that invokes Rake to load `deploy.rb`.

As it's all Rake, you can define tasks that you can invoke using `vh`. In this
example, it provides the `vh restart` command.

``` ruby
# Sample config/deploy.rb
set :host, 'your.server.com'

task :restart do
  queue 'sudo service restart apache'
end
```

The magic of Van Helsing is in the new commands it gives you.

The `queue` command queues up Bash commands to be ran on the remote server.
If you invoke `vh restart`, it will invoke the task above and run the queued
commands on the remote server `your.server.com` via SSH.

See [the command queue](#the-command-queue) for more information on the *queue*
command.

The command queue
-----------------

At the heart of it, Van Helsing is merely sugar on top of Rake to queue commands
and execute them remotely at the end.

Take a look at this minimal *deploy.rb* configuration:

``` ruby
set :user, 'john'
set :host, 'flipstack.com'

task :logs do
  queue 'echo "Contents of the log file are as follows:"'
  queue "tail -f /var/log/apache.log"
end
```

Once you type `vh logs` in your terminal, it invokes the *queue*d commands
remotely on the server using the command `ssh john@flipstack.com`.

Subtasks
--------

Van Helsing provides the helper `invoke` to invoke other tasks from a
task.

```ruby
task :down do
  invoke :maintenance_on
  invoke :restart
end

task :maintenance_on
  queue 'touch maintenance.txt'
end

task :restart
  queue 'sudo service restart apache'
end
```

In this example above, if you type `vh down`, it simply invokes the other
subtasks which queues up their commands. The commands will be ran after
everything.

Deploying
---------

Van Helsing provides the `deploy` command which *queue*s up a deploy script for
you.

``` ruby
set :host, 'flipstack.com'
set :user, 'flipstack'
set :deploy_to, '/var/www/flipstack.com'

task :deploy do
  deploy do
    # Put things that prepare the empty release folder here.
    # Commands queued here will be ran on a new release directory.
    invoke :'git:checkout'
    invoke :'bundle:install'

    # These are instructions to start the app after it's been prepared.
    to :restart do
      run 'touch tmp/restart.txt'
    end

    # This optional block defines how a broken release should be cleaned up.
    to :clean do
      queue 'log "failed deployment for #{current_version}"'
    end
  end
end
```

It works by capturing the *queue*d commands inside the block, wrapping them
in a deploy script, then *queue*ing them back in.

### How deploying works

The deploy process looks like this:

1. Decide on a release name based on the current timestamp, say,
   `2012-06-02-045823`.
2. cd to `/var/www/flipstack.com` (the *deploy_to* path).
3. Create `./releases/2012-06-02-045823` (the *release path*).
4. Invoke the queued up commands in the `deploy` block. Usually, this is a git
   checkout, along with some commands to initialize the app, such as running DB
   migrations.
5. Once it's been prepared, the release path is symlinked into `./current`.
6. Invoke the commands queued up in the `to :restart` block. These often
   commands to restart the webserver process.

If it fails at any point, the release path will be deleted. If any commands are
queued using the `to :clean` block, they will be ran. It will be as if nothing
happened.

Directory structure
-------------------

The deploy procedures make the assumption that you have a folder like so:

    /var/www/flipstack.com/     # The deploy_to path
     |-  releases/              # Holds releases, one subdir per release
     |   |- 2012-06-12-838948
     |   |- 2012-06-23-034828
     |   '- ...
     |-  shared/                # Holds files shared between releases
     |   |- logs/               # Log files are usually stored here
     |   `- ...
     '-  current/               # A symlink to the current release in releases/

It also assumes that the `deploy_to` path is fully writeable/readable for the
user we're going to SSH with.

Configuring settings
--------------------

Settings are managed using the `set` and `settings` methods. This convention is
inspired by Sinatra and Vlad.

``` ruby
set :version, "v2.0.5"

settings.version    #=> "v2.0.5"
settings.version?   #=> true
```

You can also retrieve settings without the `settings.` prefix.

``` ruby
set :version, "v2.0.5"

version    #=> "v2.0.5"
version?   #=> true
```

### Dynamic values

You can also give settings using a lambda. When the setting is retrieved, it
will be evaluated.

``` ruby
set :tag, lambda { "release/#{version}" }
set :version, "v2.0.5"

tag    #=> "release/v2.0.5"
```

### Inside and outside tasks

All of these are accessible inside and outside tasks.

``` ruby
set :admin_email, "johnsmith@gmail.com"

task :email do
  set :message, "Deploy is done"

  system "echo #{message} | mail #{admin_email}"
end
```

### Validations

If you would like an error to be thrown if a setting is not present, add a bang
at the end.

``` ruby
task :restart do
  queue "#{settings.nginx_path!}/sbin/nginx restart"
end

# $ vh restart
# Error: You must set the :nginx_path setting
```

Defaults
--------

There are a few deploy-related tasks and settings that are on by default.

### SSH settings

* `host` - Hostname to SSH to. *Required.*

* `user` - Username to connect to SSH with. Optional.

* `identity_file` - Local path to the SSH key to use. Optional.

### Deploy settings

* `deploy_to` - Path to deploy to. *Required.*

* `releases_path` - The path to where releases are kept. Defaults to
  `#{deploy_to}/releases`.

* `shared_path` - Where shared files are kept. Defaults to
  `#{deploy_to}/shared`.

* `current_path` - The path to the symlink to the current release. Defaults to
  `#{deploy_to}/current`.

* `lock_file` - The deploy lock file. A deploy does not start if this file is
  found. Defaults to `#{deploy_to}/deploy.lock`.

### Task - setup

Prepares the `deploy_to` directory for deployments. Sets up subdirectories and
sets permissions in the path.

    $ vh setup
    -----> Setting up
           $ mkdir -p /var/www/kickstack.me
           $ chmod g+r,a+rwx /var/www/kickstack.me
           $ mkdir -p /var/www/kickstack.me/releases
           $ mkdir -p /var/www/kickstack.me/shared
           ...

### Task - deploy:force_unlock

Removes the deploy lock file. If a deploy is terminated midway, it may leave a
lock file to signal that deploys shouldn't be made. This forces the removal of
that lock file.

    $ vh deploy
    -----> ERROR: another deployment is ongoing.
           Delete the lock file to continue.

    $ vh deploy:force_unlock
    -----> Unlocking
           $ rm /var/www/kickstack.me/deploy.lock

    $ vh deploy
    # The deploy should proceed now

Addons: Git
-----------

To deploy projects using git, add this to your `deploy.rb`:

``` ruby
require 'van_helsing/git'

set :repository, 'https://github.com/you/your-app.git'
```

### Settings

This introduces the following settings:

* `repository` - The repository path to clone from. *Required.*

* `revision` - The SHA1 of the commit to be deployed. Defaults to whatever is
the current HEAD in your local copy.

### Task - git:clone

Clones from the repo into the current folder.

Addons: Bundler
---------------

To manage Bundler installations, add this to your `deploy.rb`:

``` ruby
require 'van_helsing/bundler'
```

### Settings

This introduces the following settings:

* `bundle_path` - The path where bundles are going to be installed. Defaults to
`./vendor/bundler`.

* `bundle_options` - Options that will be passed onto `bundle install`.  
  Defaults to
`--without development:test --path "#{bundle_path}" --binstubs bin/
--deployment"`.

### Task - bundle:install

Invokes `bundle:install` on the current directory, creating the bundle
path (specified in `bundle_path`), and invoking `bundle install`.

The `bundle_path` is only created if `bundle_path` is set (which is on
by default).

Addons: Rails
-------------

To manage Rails project installations, add this to your `deploy.rb`:

``` ruby
require 'van_helsing/rails'
```

### Settings

This introduces the following settings. All of them are optional.

 * `rake` - The `rake` command. Defaults to `RAILS_ENV="#{rails_env}" bundle 
 exec rake`.

 * `rails_env` - The environment to run rake commands in. Defaults to
 `production`.

### Task - rails:db_migrate

Invokes rake to migrate the database using `rake db:migrate`.

### Task - rails:assets_precompile

Precompiles assets. This invokes `rake assets:precomplie`.

It also checks the current version to see if it has assets compiled. If it does,
it reuses them, skipping the compilation step. To stop this behavior, invoke
the `vh` command with `force_assets=1`.

### Task - rails:assets_precompile:force

Precompiles assets. This always skips the "reuse old assets if possible" step.


