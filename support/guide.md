
User guide
==========

Setting up a project
--------------------

Let's deploy a project using Mina.

### Step 1: Create a config/deploy.rb

In your project, type `mina init` to create a sample of this file.

    $ mina init
    Created config/deploy.rb.

This is just a Rake file with tasks! See [About deploy.rb](#about-deployrb) for 
more info on what *deploy.rb* is. You will want to at least configure your
server:

~~~ ruby
# config/deploy.rb
set :user, 'username'
set :domain, 'your.server.com'
set :deploy_to, '/var/www/flipstack.com'
...
~~~

### Step 2: Set up your server

Make a directory in your server called `/var/www/flipstack.com` (in *deploy_to*)
change it's ownership to the correct user.

    $ ssh username@your.server.com

    # Once in your server, create the deploy folder:
    ~@your.server.com$ mkdir /var/www/flipstack.com
    ~@your.server.com$ chown -R username /var/www/flipstack.com

### Step 3: Run 'mina setup'

Back at your computer, do `mina setup` to set up the [folder 
structure](#directory_structure) in this path. This will connect to your server 
via SSH and create the right directories.

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

About deploy.rb
---------------

The file `deploy.rb` is simply a Rakefile invoked by Rake. In fact, `mina` is
mostly an alias that invokes Rake to load `deploy.rb`.

~~~ ruby
# Sample config/deploy.rb
set :domain, 'your.server.com'

task :restart do
  queue 'sudo service restart apache'
end
~~~

As it's all Rake, you can define tasks that you can invoke using `mina`. In this
example, it provides the `mina restart` command.

The magic of Mina is in the new commands it gives you.

The `queue` command queues up Bash commands to be run on the remote server.
If you invoke `mina restart`, it will invoke the task above and run the queued
commands on the remote server `your.server.com` via SSH.

See [the command queue](#the-command-queue) for more information on the *queue*
command.

The command queue
-----------------

At the heart of it, Mina is merely sugar on top of Rake to queue commands
and execute them remotely at the end. Take a look at this minimal *deploy.rb*
configuration:

~~~ ruby
# config/deploy.rb
set :user, 'john'
set :domain, 'flipstack.com'

task :logs do
  queue 'echo "Contents of the log file are as follows:"'
  queue "tail -f /var/log/apache.log"
end
~~~

Once you type `mina logs` in your terminal, it invokes the *queue*d commands
remotely on the server using the command `ssh john@flipstack.com`.

~~~ sh
$ mina logs --simulate
# Execute the following commands via
# ssh john@flipstack.com:
#
echo "Contents of the log file are as follows:"
tail -f /var/log/apache.log
~~~

Subtasks
--------

Mina provides the helper `invoke` to invoke other tasks from a
task.

~~~ ruby
# config/deploy.rb
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
~~~

In this example above, if you type `mina down`, it simply invokes the other
subtasks which queues up their commands. The commands will be run after
everything.

Directory structure
-------------------

The deploy procedures make the assumption that you have a folder like so:

    /var/www/flipstack.com/     # The deploy_to path
     |-  releases/              # Holds releases, one subdir per release
     |   |- 1/
     |   |- 2/
     |   |- 3/
     |   '- ...
     |-  shared/                # Holds files shared between releases
     |   |- logs/               # Log files are usually stored here
     |   `- ...
     '-  current/               # A symlink to the current release in releases/

It also assumes that the `deploy_to` path is fully writeable/readable for the
user we're going to SSH with.

Deploying
---------

Mina provides the `deploy` command which *queue*s up a deploy script for
you.

~~~ ruby
# config/deploy.rb
set :domain, 'flipstack.com'
set :user, 'flipstack'
set :deploy_to, '/var/www/flipstack.com'
set :repository, 'http://github.com/flipstack/flipstack.git'

task :deploy do
  deploy do
    # Put things that prepare the empty release folder here.
    # Commands queued here will be run on a new release directory.
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
~~~

It works by capturing the *queue*d commands inside the block, wrapping them
in a deploy script, then *queue*ing them back in.

### How deploying works

Here is an example of a deploy! (Note that some commands have been simplified
to illustrate the point better.)

### Step 1: Build it

The deploy process builds a new temp folder with instructions you provide.
In this example, it will do `git:clone` and `bundle:install`.

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

### Step 2: Move it to releases

Once the project has been built, it will be moved to `releases/`. A symlink
called `current/` will be created to point to the active release.

    $
    -----> Moving to releases/4
           $ mv "./tmp/build-128293482394" "releases/4"
    -----> Symlinking to current
           $ ln -nfs releases/4 current

### Step 3: Launch it

Invoke the commands queued up in the `to :launch` block. These often
commands to restart the webserver process. Once this in complete, you're done!

    $
    -----> Launching
           $ cd releases/4
           $ sudo service nginx restart
    -----> Done. Deployed v4

### What about failure?

If it fails at any point, the release path will be deleted. If any commands are
queued using the `to :clean` block, they will be run. It will be as if nothing
happened. Lets see what happens if a build fails:

    $
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

Command line options
--------------------

Basic usage:

    $ mina [OPTIONS] [TASKS] [VAR1=val VAR2=val ...]

### Options

* `-v` / `--verbose` - This will show commands being done on the server. Off by
  default.

* `-S` / `--simulate` - This will not invoke any SSH connections; instead, it
  will simply output the script it builds.

* `-t` / `--trace` - Show backtraces when errors occur.

* `-f FILE` - Use a custom deploy.rb configuration.

* `-V` / `--version` - Shows the current version.

### Tasks

There are many tasks available. See the [tasks reference](http://mina-deploy.github.io/mina/tasks/), or
type `mina tasks`.

### Variables

You may specify additional variables in the `KEY=value` style, just like Rake.
You can add as many variables as needed.

    $ mina restart on=staging

    # This sets the ENV['on'] variable to 'staging'.

