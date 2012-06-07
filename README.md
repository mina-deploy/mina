# Mina [![status](https://secure.travis-ci.org/nadarei/mina.png?branch=master)](http://travis-ci.org/nadarei/mina)

Really fast deployer and server automation tool.

Mina works really fast because it's a deploy Bash script generator. It
generates an entire procedure as a Bash script and runs it remotely in the
server.

Compare this to the likes of Vlad or Capistrano, where each command
is ran separately on their own SSH sessions. Mina only creates *one* SSH
session per deploy, minimizing the SSH connection overhead.

    $ gem install mina
    $ mina

Features
--------

* __Really fast.__ Mina only makes one SSH connection per deploy. It
  builds a Bash script and executes it remotely, reducing the overhead of
  creating SSH connections to do processing locally (like Vlad or Capistrano
  does).

* __Safe deploys.__ New releases are built on a temp folder. If the deploy
  script fails at any point, the build is deleted and it'd be as if nothing
  happened.

* __Locks.__ Deploy scripts rely on a lockfile ensuring only one deploy can
  happen at a time.

* __Works with anything.__ While Mina is built with Rails projects it
  mind, it can be used on just about any type of project deployable via SSH,
  Ruby or not.

* __Built with Rake.__ Setting up tasks will be very familiar! No YAML files
  here. Everything is written in Ruby, giving you the power to be as flexible in
  your configuration as needed.

Setting up a project
--------------------

Let's deploy a project using Mina.

### Step 1: Create a config/deploy.rb

In your project, type `mina init` to create a sample of this file.

This is just a Rake file with tasks!

    $ mina init
    Created config/deploy.rb.

See [About deploy.rb](#about_deployrb) for more info on what *deploy.rb* is.

### Step 2: Set up your server

Make a directory in your server called `/var/www/flipstack.com` (in *deploy_to*)
change it's ownership to the correct user.

    # SSH into your server, then:
    $ mkdir /var/www/flipstack.com
    $ chown -R username /var/www/flipstack.com

    # Make sure 'username' is the same as what's on deploy.rb

### Step 3: Run 'mina setup'

Now do `mina setup` to set up the [folder structure](#directory_structure) in this
path. This will connect to your server via SSH and create the right directories.

    $ mina setup
    -----> Creating folders... done.

See [directory structure](#directory_structure) for more info.

### Step 4: Deploy!

Use `mina deploy` to run the `deploy` task defined in *config/deploy.rb*.

    $ mina deploy
    -----> Deploying to 2012-06-12-040248
           ...
           Lots of things happening...
           ...
    -----> Done.

Command line options
--------------------

* `--verbose` - This will show commands being done on the server. Off by
  default.

* `--simulate` - This will not invoke any SSH connections; instead, it will
  simply output the script it builds.

About deploy.rb
---------------

The file `deploy.rb` is simply a Rakefile invoked by Rake. In fact, `mina` is
mostly an alias that invokes Rake to load `deploy.rb`.

As it's all Rake, you can define tasks that you can invoke using `mina`. In this
example, it provides the `mina restart` command.

``` ruby
# Sample config/deploy.rb
set :domain, 'your.server.com'

task :restart do
  queue 'sudo service restart apache'
end
```

The magic of Mina is in the new commands it gives you.

The `queue` command queues up Bash commands to be ran on the remote server.
If you invoke `mina restart`, it will invoke the task above and run the queued
commands on the remote server `your.server.com` via SSH.

See [the command queue](#the_command_queue) for more information on the *queue*
command.

The command queue
-----------------

At the heart of it, Mina is merely sugar on top of Rake to queue commands
and execute them remotely at the end.

Take a look at this minimal *deploy.rb* configuration:

``` ruby
set :user, 'john'
set :domain, 'flipstack.com'

task :logs do
  queue 'echo "Contents of the log file are as follows:"'
  queue "tail -f /var/log/apache.log"
end
```

Once you type `mina logs` in your terminal, it invokes the *queue*d commands
remotely on the server using the command `ssh john@flipstack.com`.

```
# Run it in simulation mode so we see the command it will invoke:
$ mina logs --simulate
(
  echo "Contents of the log file are as follows:"
  tail -f /var/log/apache.log
) | ssh john@flipstack.com -- bash -
```

Subtasks
--------

Mina provides the helper `invoke` to invoke other tasks from a
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

In this example above, if you type `mina down`, it simply invokes the other
subtasks which queues up their commands. The commands will be ran after
everything.

Deploying
---------

Mina provides the `deploy` command which *queue*s up a deploy script for
you.

``` ruby
set :domain, 'flipstack.com'
set :user, 'flipstack'
set :deploy_to, '/var/www/flipstack.com'
set :repository, 'http://github.com/flipstack/flipstack.git'

task :deploy do
  deploy do
    # Put things that prepare the empty release folder here.
    # Commands queued here will be ran on a new release directory.
    invoke :'git:clone'
    invoke :'bundle:install'

    # These are instructions to start the app after it's been prepared.
    to :launch do
      queue 'touch tmp/restart.txt'
    end

    # This optional block defines how a broken release should be cleaned up.
    to :clean do
      queue 'log "failed deployment"'
    end
  end
end
```

It works by capturing the *queue*d commands inside the block, wrapping them
in a deploy script, then *queue*ing them back in.

How deploying works
-------------------

Here is an example of a deploy! (Note that some commands have been simplified
to illustrate the point better.)

### Step 1: Build it

The deploy process builds a new temp folder with instructions you provide.
In this example, it will do `git:clone` and `bundle:install`.

```
$ mina deploy --verbose
-----> Creating the build path
       $ mkdir tmp/build-128293482394
-----> Cloning the Git repository
       $ git clone https://github.com/flipstack/flipstack.git . -n --recursive
       Cloning... done.
-----> Installing gem dependencies using Bundler
       $ bundle install --without development:test
       Using i18n (0.6.0)
       Using multi_json (1.0.4)
       ...
       Your bundle is complete! It was installed to ./vendor/bundle
```

### Step 2: Move it to releases

Once the project has been built, it will be moved to `releases/`. A symlink
called `current/` will be created to point to the active release.

```
-----> Moving to releases/4
       $ mv "./tmp/build-128293482394" "releases/4"
-----> Symlinking to current
       $ ln -nfs releases/4 current
```

### Step 3: Launch it

Invoke the commands queued up in the `to :launch` block. These often
commands to restart the webserver process. Once this in complete, you're done!

```
-----> Launching
       $ cd releases/4
       $ sudo service nginx restart
-----> Done. Deployed v4
```

### What about failure?

If it fails at any point, the release path will be deleted. If any commands are
queued using the `to :clean` block, they will be ran. It will be as if nothing
happened.

```
# Lets see what happens if a build fails:
-----> Launching
       $ cd releases/4
       $ sudo service nginx restart
       Starting nginx... error: can't start service
-----> ERROR: Deploy failed.
-----> Cleaning up build
       $ rm -rf tmp/build-128293482394
-----> Unlinking current
       $ ln -nfs releases/3 current
       OK
```

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

# $ mina restart
# Error: You must set the :nginx_path setting
```

Settings
--------

There are a few deploy-related tasks and settings that are on by default.

### term_mode
If set to `:pretty`, prettifies the output with indentations. Otherwise, simply
invokes the commands.

Invoking `deploy` or `deploy_script` defaults this to `:pretty`.
(Default with deploys.)

``` ruby
# Example:
set :term_mode, :pretty
set :term_mode, nil
```

### domain
Hostname to SSH to. *Required.*

``` ruby
# Example:
set :domain, 'flipstack.me'
set :user, 'flipstack_www'                # Optional
set :identity_file, 'keys/deploy.pem'     # Optional

# This will invoke SSH sessions with:
# $ ssh flipstack_www@flipstack.me -i keys/deploypem
```

### user
Username to connect to SSH with. Optional.
See [domain](#domain) for an example.

### identity_file
Local path to the SSH key to use. Optional.
See [domain](#domain) for an example.

### deploy_to
Path to deploy to. *Required.*

``` ruby
# Example:
set :deploy_to, '/var/www/flipstack.me'
set :releases_path, 'releases'
set :shared_path, 'shared'
set :current_path, 'current'
set :lock_file, 'deploy.lock'

# This means the following paths will be
# created on `mina setup`:
#    /var/www/flipstack.me/
#    /var/www/flipstack.me/releases/
#    /var/www/flipstack.me/shared/
```

### releases_path
The path to where releases are kept. Defaults to `releases`.
See [deploy_to](#deploy_to) for an example.

### shared_path
Where shared files are kept. Defaults to `shared`.
See [deploy_to](#deploy_to) for an example.

### current_path
The path to the symlink to the current release. Defaults to `current`.
See [deploy_to](#deploy_to) for an example.

### lock_file
The deploy lock file. A deploy does not start if this file is
found. Defaults to `deploy.lock`.
See [deploy_to](#deploy_to) for an example.

### repository
The URL for the repository.
**Required** when you use `require 'mina/git'`.

``` ruby
# config/deploy.rb
require 'mina/git'

set :repository, 'https://github.com/you/your-app.git'
set :revision, 'master'  # Optional
```

### revision
The SHA1 of the commit to be deployed. Defaults to whatever is
the current HEAD in your local copy.
See [repository](#repository) for an example.

### bundle_path
The path where bundles are going to be installed. Optional. Defaults to
`./vendor/bundler`.

This is only relevant if you require the bundler addon with `require 
'mina/bundler'`.

### bundle_options
Options that will be passed onto `bundle install`.  Defaults to
`--without development:test --path "#{bundle_path}" --binstubs bin/
--deployment"`.

This is only relevant if you require the bundler addon with `require 
'mina/bundler'`.

### bundle_prefix
Prefix to run commands via Bundler. Defaults to
`RAILS_ENV="#{rails_env}" bundle exec`.

This is only relevant if you require the bundler addon with `require 
'mina/rails'`.

### rake
The `rake` command. Defaults to `#{bundle_prefix} rake`.

This is only relevant if you require the bundler addon with `require 
'mina/rails'`.

### rails
The `rails` command. Defaults to `#{bundle_prefix} rails`.

This is only relevant if you require the bundler addon with `require 
'mina/rails'`.

### rails_env
The environment to run rake commands in. Defaults to `production`.

This is only relevant if you require the bundler addon with `require 
'mina/rails'`.

Tasks
-----

You may define your own tasks just as you would in Rake, but these tasks come 
default to all Mina deploy scripts.

Some of them are meant to be invoking in the command line (like `mina setup`),
 and some of them are meant to be invoked in scripts (like `invoke
:'git:clone'`).

You can type `mina tasks` in the command line to see all tasks available.

### setup

Prepares the `deploy_to` directory for deployments. Sets up subdirectories and
sets permissions in the path.

    $ mina setup
    -----> Setting up
           $ mkdir -p /var/www/kickstack.me
           $ chmod g+r,a+rwx /var/www/kickstack.me
           $ mkdir -p /var/www/kickstack.me/releases
           $ mkdir -p /var/www/kickstack.me/shared
           ...

### run

Runs a command in the `deploy_to` path.

    $ mina run["tail -f shared/logs/error.log"]

### deploy:force_unlock

Removes the deploy lock file. If a deploy is terminated midway, it may leave a
lock file to signal that deploys shouldn't be made. This forces the removal of
that lock file.

    $ mina deploy
    -----> ERROR: another deployment is ongoing.
           Delete the lock file to continue.

    $ mina deploy:force_unlock
    -----> Unlocking
           $ rm /var/www/kickstack.me/deploy.lock

    $ mina deploy
    # The deploy should proceed now


### git:clone
Clones the git repository defined in [repository](#repository).
Usually used in deploy scripts.

To use this, you must add `require 'mina/git'` to your *deploy.rb*.

``` ruby
# config/deploy.rb
require 'mina/git'

set :repository, 'https://github.com/you/your-app.git'
set :revision, 'master'  # Optional

task :deploy do
  deploy do
    invoke :'git:clone'
  end
end
```

### bundle:install
Invokes `bundle:install` on the current directory, creating the bundle
path (specified in `bundle_path`), and invoking `bundle install`.
Usually used in deploy scripts.

The `bundle_path` is only created if `bundle_path` is set (which is on
by default).

This is only relevant if you require the bundler addon with `require
'mina/bundler'`.

``` ruby
# config/deploy.rb
require 'mina/git'
require 'mina/bundler'   # <- don't forget

# ... settings here

task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'
  end
end

# $ mina deploy --verbose
# ...
# ------> Installing gem dependencies using Bundler
#         $ bundle install --without test:development --deployment
```

### rails:db_migrate

Invokes rake to migrate the database using `rake db:migrate`.

To use this, you must add `require 'mina/rails'` to your *deploy.rb*.

``` ruby
# config/deploy.rb
require 'mina/git'
require 'mina/bundler'   # <- don't forget

# ... settings here

task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
  end
end
```

### rails:assets_precompile

Precompiles assets. This invokes `rake assets:precompile`. This is relevant to
Rails 3.1+ projects.

It also checks the current version to see if it has assets compiled. If it does,
it reuses them, skipping the compilation step. To stop this behavior, invoke
the `mina` command with `force_assets=1`.

To use this, you must add `require 'mina/rails'` to your *deploy.rb*.

### rails:assets_precompile:force

Precompiles assets. This always skips the "reuse old assets if possible" step.

To use this, you must add `require 'mina/rails'` to your *deploy.rb*.

Development & testing
---------------------

To test out stuff in development:

    # Run specs
    $ rspec
    $ rspec -t ssh     # Run SSH tests (read test_env/config/deploy.rb first)
    $ rake=0.9 rspec
    $ rake=0.8 rspec

    # Alias your 'mina' to use it everywhere
    $ alias mina="`pwd -LP`/bin/mina"

### Doing test deploys

Try out the test environment:

    $ cd test_env
    $ mina deploy --simulate
    $ mina deploy

    # There's an rspec task for it too
    $ rspec -t ssh

### Gem management

    # To release the gem:
    # Install the Git changelog helper: https://gist.github.com/2880525
    $ vim lib/mina/version.rb
    $ git clog -w
    $ vim HISTORY.md
    $ rake release

    $ rake build      # Builds the gem file
    $ rake install    # Installs the gem locally

Issues
------

File issues at the [issue tracker][issues] (github.com). You may also look at
the [Trello board][trello] (trello.com) we use for development.

Acknowledgements
----------------

© 2012, Nadarei. Released under the [MIT 
License](http://www.opensource.org/licenses/mit-license.php).

Mina is authored and maintained by [Rico Sta. Cruz][rsc] and [Michael 
Galero][mg] with help from its [contributors][c]. It is sponsored by our 
startup, [Nadarei][nd].

 * [Nadarei](http://nadarei.co) (nadarei.co)
 * [Github](http://github.com/nadarei) (@nadarei)

Rico:

 * [My website](http://ricostacruz.com) (ricostacruz.com)
 * [Github](http://github.com/rstacruz) (@rstacruz)
 * [Twitter](http://twitter.com/rstacruz) (@rstacruz)

Michael:

 * [My website][mg] (michaelgalero.com)
 * [Github](http://github.com/mikong) (@mikong)

[rsc]: http://ricostacruz.com
[mg]:  http://devblog.michaelgalero.com/
[c]:   http://github.com/nadarei/mina/contributors
[nd]:  http://nadarei.co
[issues]: https://github.com/nadarei/mina/issues
[trello]: https://trello.com/board/mina/4fc8b3023d9c9a4d72e573e6
