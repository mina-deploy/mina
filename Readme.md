# Mina

Really fast deployer and server automation tool.

Mina works really fast because it's a deploy Bash script generator. It
generates an entire procedure as a Bash script and runs it remotely in the
server.

Compare this to the likes of Vlad or Capistrano, where each command
is run separately on their own SSH sessions. Mina only creates *one* SSH
session per deploy, minimizing the SSH connection overhead.

    $ gem install mina
    $ mina

[![Build Status](https://travis-ci.org/mina-deploy/mina.svg?branch=master)](https://travis-ci.org/mina-deploy/mina) [![Gem Version](https://badge.fury.io/rb/mina.svg)](http://badge.fury.io/rb/mina) [![Inline docs](http://inch-ci.org/github/mina-deploy/mina.svg?branch=master)](http://inch-ci.org/github/mina-deploy/mina)

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


# Helpers

### invoke
Invokes another Rake task.
By default if the task has already been invoked it will not been executed again (see the `:reenable` option).

Invokes the task given in `task`. Returns nothing.

~~~ ruby
invoke :'git:clone'
invoke :restart
~~~

Options:
  reenable (bool) - Execute the task even next time.

task.to_s is a ruby 1.8.7 fix

### erb
Evaluates an ERB block in the current scope and returns a string.

~~~ ruby
a = 1
b = 2
# Assuming foo.erb is <%= a %> and <%= b %>
puts erb('foo.erb')
#=> "1 and 2"
~~~

Returns the output string of the ERB template.

### run!
SSHs into the host and runs the code that has been queued.

This is already automatically invoked before Rake exits to run all
commands that have been queued up.

~~~ ruby
queue "sudo restart"
run!
~~~

Returns nothing.

### run_local!
runs the code locally that has been queued.
Has to be in :before_hook or :after_hook queue

This is already automatically invoked before Rake exits to run all
commands that have been queued up.

~~~ ruby
to :before_hook do
  queue "cp file1 file2"
end
run_local!(:before_hook)
~~~

Returns nothing.

### report_time
Report time elapsed in the block.
Returns the output of the block.

~~~ ruby
report_time do
  sleep 2
  # do other things
end
# Output:
# Elapsed time: 2.00 seconds
~~~

### measure
Measures the time (in seconds) a block takes.
Returns a [time, output] tuple.

### mina_cleanup
__Internal:__ Invoked when Rake exits.

Returns nothing.

## Errors

### die
Exits with a nice looking message.
Returns nothing.

~~~ ruby
die 2
die 2, "Tests failed"
~~~

### error
__Internal:__ Prints to stdout.
Consider using `print_error` instead.

## Queueing

### queue
Queues code to be run.

This queues code to be run to the current code bucket (defaults to `:default`).
To get the things that have been queued, use commands[:default]

Returns nothing.

~~~ ruby
queue "sudo restart"
queue "true"
commands == ['sudo restart', 'true']
~~~

### queue!
Shortcut for `queue`ing a command that shows up in verbose mode.

### echo_cmd
Converts a bash command to a command that echoes before execution.
Used to show commands in verbose mode. This does nothing unless verbose mode is on.

Returns a string of the compound bash command, typically in the format of
`echo xx && xx`. However, if `verbose_mode?` is false, it returns the
input string unharmed.

~~~ ruby
echo_cmd("ln -nfs releases/2 current")
#=> echo "$ ln -nfs releases/2 current" && ln -nfs releases/2 current
~~~

## Commands

### commands
Returns an array of queued code strings.

You may give an optional `aspect`.

Returns an array of strings.

~~~ ruby
queue "sudo restart"
queue "true"
to :clean do
  queue "rm"
end
commands == ["sudo restart", "true"]
commands(:clean) == ["rm"]
~~~

### isolate
Starts a new block where new `commands` are collected.

Returns nothing.

~~~ ruby
queue "sudo restart"
queue "true"
commands.should == ['sudo restart', 'true']
isolate do
  queue "reload"
  commands.should == ['reload']
end
commands.should == ['sudo restart', 'true']
~~~

### in_directory
Starts a new block where #commands are collected, to be executed inside `path`.

Returns nothing.

~~~ ruby
in_directory './webapp' do
  queue "./reload"
end
commands.should == ['cd ./webapp && (./reload && true)']
~~~

### to
Defines instructions on how to do a certain thing.
This makes the commands that are `queue`d go into a different bucket in commands.

Returns nothing.

~~~ ruby
to :prepare do
  run "bundle install"
end
to :launch do
  run "nginx -s restart"
end
commands(:prepare) == ["bundle install"]
commands(:restart) == ["nginx -s restart"]
~~~

## Settings helpers

### set
Sets settings.
Sets given symbol `key` to value in `value`.

Returns the value.

~~~ ruby
set :domain, 'kickflip.me'
~~~

### set_default
Sets default settings.
Sets given symbol `key` to value in `value` only if the key isn't set yet.

Returns the value.

~~~ ruby
set_default :term_mode, :pretty
set :term_mode, :system
settings.term_mode.should == :system
set :term_mode, :system
set_default :term_mode, :pretty
settings.term_mode.should == :system
~~~

### settings
Accesses the settings hash.

~~~ ruby
set :domain, 'kickflip.me'
settings.domain  #=> 'kickflip.me'
domain           #=> 'kickflip.me'
~~~

### method_missing
Hook to get settings.
See #settings for an explanation.

Returns things.

## Command line mode helpers

### verbose_mode?
Checks if Rake was invoked with --verbose.

Returns true or false.

~~~ ruby
if verbose_mode?
  queue %[echo "-----> Starting a new process"]
end
~~~

### simulate_mode?
Checks if Rake was invoked with --simulate.

Returns true or false.

## Internal helpers

### indent
Indents a given code block with `count` spaces before it.

### unindent
__Internal:__ Normalizes indentation on a given string.

Returns the normalized string without extraneous indentation.

~~~ ruby
puts unindent %{
  Hello
    There
}
# Output:
# Hello
#   There
~~~

### reindent
Resets the indentation on a given code block.

### capture
Returns the output of command via SSH.

# Helpers: Deploy helpers
Helpers for deployment.

### deploy
Wraps the things inside it in a deploy script and queues it.
This generates a script using deploy_script and queues it.

Returns nothing.

### deploy_script
Wraps the things inside it in a deploy script.

~~~ ruby
script = deploy_script do
  invoke :'git:checkout'
end
queue script
~~~

Returns the deploy script as a string, ready for `queue`ing.

# Modules: Bundler
Adds settings and tasks for managing Ruby Bundler.

~~~ ruby
require 'mina/bundler'
~~~

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### bundle_bin
Sets the bundle path.

### bundle_path
Sets the path to where the gems are expected to be.

This path will be symlinked to `./shared/bundle` so that the gems cache will
be shared between all releases.

### bundle_withouts
Sets the colon-separated list of groups to be skipped from installation.

### bundle_options
Sets the options for installing gems via Bundler.

## Deploy tasks
These tasks are meant to be invoked inside deploy scripts, not invoked on
their own.

### bundle:install
Installs gems.

# Modules: Default
This module is loaded when invoking `mina` with or without a project.

## Settings
Here are some of the common settings. All settings are optional unless
otherwise noted.

### deploy_to
(Required) Path to deploy to.

### domain
(Required) Host name to deploy to.

### port
SSH port number.

### forward_agent
If set to `true`, enables SSH agent forwarding.

### identity_file
The local path to the SSH private key file.

### ssh_options
Switches to be passed to the `ssh` command.

### env_vars
Environment variables to be passed to `ssh` command. (e.g. "foo=bar baz=1")

## Tasks
Any and all of these settings can be overriden in your `deploy.rb`.

### environment
Make the `:environment` task exist by default. This is meant to be overridden
by users.

### init
Initializes a new Mina project.

~~~ ruby
$ mina init
~~~

### help
Shows the help screen.

### tasks
Display all tasks in a nice table.

~~~ ruby
$ mina tasks
~~~

### ssh
Connects to the server via ssh and cd to deploy_to folder

~~~ ruby
$ mina ssh
~~~

# Modules: Deployment
This module is automatically loaded for all Mina projects.

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### releases_path
(default: 'releases')

### shared_path
(default: 'shared')

### current_path
(default: 'current_path')

### lock_file
Name of the file to generate while a deploy is currently ongoing.
(default: 'deploy.lock')

### keep_releases
Number of releases to keep when doing the `deploy:cleanup` task.
(default: 5)

## Tasks

### deploy:force_unlock
Forces a deploy unlock by deleting the lock file.

~~~ ruby
$ mina deploy:force_unlock
~~~

You can also combine that task with `deploy`:

~~~ ruby
$ mina deploy:force_unlock deploy
~~~

### deploy:link_shared_paths
Links the shared paths in the `shared_paths` setting.

### deploy:cleanup
Cleans up old releases.

By default, the last 5 releases are kept on each server (though you can
change this with the keep_releases setting).  All other deployed revisions
are removed from the servers."

### deploy:rollback
Rollbacks the latest release.

Changes the current link to previous release, and deletes the newest deploy release
Does NOT rollback the database, use

~~~ ruby
mina "rake[db:rollback]"
~~~

Delete existing sym link and create a new symlink pointing to the previous release

Remove latest release folder (current release)

### setup
Sets up a site's directory structure.

### run[]
Runs a command on a server.

~~~ ruby
$ mina "run[tail -f logs.txt]"
~~~

# Modules: Foreman
Adds settings and tasks for managing projects with [foreman].

NOTE: Requires sudo privileges

[foreman]: http://rubygems.org/ddolar/foreman

   require 'mina/foreman'

## Common usage

   set :application, "app-name"

   task :deploy => :environment do
~~~ ruby
 deploy do
   # ...
   invoke 'foreman:export'
   # ...
 end
 to :launch do
   invoke 'foreman:restart'
 end
~~~

   end

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### foreman_app
Sets the service name that foreman will export to upstart. Uses *application*
variable as a default. It should be set, otherwise export command will fail.

### foreman_user
Sets the user under which foreman will execute the service. Defaults to *user*

### foreman_log
Sets the foreman log path. Defaults to *shared/log*

encoding: utf-8

# Modules: Git
Adds settings and tasks related to managing Git.

~~~ ruby
require 'mina/git'
~~~

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### branch
Sets the branch to be deployed.

## Deploy tasks
These tasks are meant to be invoked inside deploy scripts, not invoked on
their own.

### git:clone
Clones the Git repository. Meant to be used inside a deploy script.

### git:revision
Gets the current git revision deployed on server.

# Modules: Rails
Adds settings and tasks for managing Rails projects.

~~~ ruby
require 'mina/rails'
~~~

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### rails_env
Sets the Rails environment for `rake` and `rails` commands.

Note that changing this will NOT change the environment that your application
is run in.

### bundle_prefix
Prefix for Bundler commands. Often to something like `RAILS_ENV=production
bundle exec`.

~~~ ruby
queue! "#{bundle_prefix} annotate -r"
~~~

### rake
The prefix for `rake` commands. Use like so:

~~~ ruby
queue! "#{rake} db:migrate"
~~~

### rails
The prefix for `rails` commands. Use like so:

~~~ ruby
queue! "#{rails} console"
~~~

### asset_paths
The paths to be checked.

Whenever assets are compiled, the asset files are checked if they have
changed from the previous release.

If they're unchanged, compiled assets will simply be copied over to the new
release.

Override this if you have custom asset paths declared in your Rails's
`config.assets.paths` setting.

### compiled_asset_path
The path to be copied to the new release.

The path your assets are compiled to. If your `assets_path` assets have changed,
this is the folder that gets copied accross from the current release to the new release.

Override this if you have custom public asset paths.

### rake_assets_precompile
The command to invoke when precompiling assets.
Override me if you like.

----

Macro used later by :rails, :rake, etc

## Command-line tasks
These tasks can be invoked in the command line.

### rails[]
Invokes a rails command.

~~~ ruby
$ mina "rails[console]"
~~~

### rake[]
Invokes a rake command.

~~~ ruby
$ mina "rake[db:migrate]"
~~~

### console
Opens the Ruby console for the currently-deployed version.

~~~ ruby
$ mina console
~~~

### log
Tail log from server

~~~ ruby
$ mina log
~~~

## Deploy tasks
These tasks are meant to be invoked inside deploy scripts, not invoked on
their own.

### rails:db_migrate

### rails:db_migrate:force

### rails:db_create

### rails:db_rollback

### rails:assets_precompile:force

### rails:assets_precompile

# Modules: rbenv
Adds settings and tasks for managing [rbenv] installations.

[rbenv]: https://github.com/sstephenson/rbenv

~~~ ruby
require 'mina/rbenv'
~~~

## Common usage

~~~ ruby
task :environment do
  invoke :'rbenv:load'
end
task :deploy => :environment do
  ...
end
~~~

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### rbenv_path
Sets the path where *rbenv* is installed.

You may override this if rbenv is placed elsewhere in your setup.

## Tasks

### rbenv:load
Loads the *rbenv* runtime.

# Modules: RVM
Adds settings and tasks for managing [RVM] installations.

[rvm]: http://rvm.io

~~~ ruby
require 'mina/rvm'
~~~

## Common usage

~~~ ruby
task :environment do
  invoke :'rvm:use[ruby-1.9.3-p125@gemset_name]'
end
task :deploy => :environment do
  ...
end
~~~

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### rvm_path
Sets the path to RVM.

You can override this in your projects if RVM is installed in a different
path, say, if you have a system-wide RVM install.

## Tasks

### rvm:use[]
Uses a given RVM environment provided as an argument.

This is usually placed in the `:environment` task.

~~~ ruby
task :environment do
  invoke :'rvm:use[ruby-1.9.3-p125@gemset_name]'
end
~~~

### rvm:wrapper[]
Creates a rvm wrapper for a given executable.

This is usually placed in the `:setup` task.

~~~ ruby
task ::setup => :environment do
  ...
  invoke :'rvm:wrapper[ruby-1.9.3-p125@gemset_name,wrapper_name,binary_name]'
end
~~~

Adds settings and tasks for managing Node packages.

~~~ ruby
require 'mina/npm'
~~~

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### npm_bin
Sets the npm binary.

### bower_bin
Sets the bower binary.

### grunt_bin
Sets the grunt binary.

### npm_options
Sets the options for installing modules via npm.

### bower_options
Sets the options for installing modules via bower.

### grunt_options
Sets the options for grunt.

### grunt_task
Sets the task parameters for grunt.

## Deploy tasks
These tasks are meant to be invoked inside deploy scripts, not invoked on
their own.

### npm:install
Installs node modules. Takes into account if executed `in_directory` and namespaces the installed modules in the shared folder.

### bower:install
Installs bower modules. Takes into account if executed `in_directory` and namespaces the installed modules in the shared folder.

### grunt:install
Launch a task with grunt. Set the grunt_task (defaults to \"build\") variable before calling this.

# Modules: Whenever
Adds settings and tasks for managing projects with [whenever].

[whenever]: http://rubygems.org/gems/whenever

## Common usage
~~~ ruby
require 'mina/whenever'
task :deploy => :environment do
  deploy do
    ...
  to :launch do
    invoke :'whenever:update'
  end
end
~~~

3rd party modules
------

* [mina-rollbar](https://github.com/code-lever/mina-rollbar)
* [mina-stack](https://github.com/div/mina-stack)
* [mina-rsync](https://github.com/moll/mina-rsync)
* [mina-sidekiq](https://github.com/Mic92/mina-sidekiq)
* [mina-delayed_job](https://github.com/d4be4st/mina-delayed_job)
* [mina-nginx](https://github.com/hbin/mina-nginx)
* [mina-newrelic](https://github.com/navinpeiris/mina-newrelic)
* [mina-rbenv-addons](https://github.com/stas/mina-rbenv-addons)
* [mina-multistage](https://github.com/endoze/mina-multistage)
* [mina-s3](https://github.com/stas/mina-s3)
* [mina-scp](https://github.com/adie/mina-scp)
* [mina-hooks](https://github.com/elskwid/mina-hooks)
* [mina-slack](https://github.com/TAKAyukiatkwsk/mina-slack)
* [mina-cakephp](https://github.com/mobvox/mina-cakephp)
* [mina-unicorn](https://github.com/openteam/mina-unicorn)
* [mina-puma](https://github.com/sandelius/mina-puma)
* [mina-mercurial](https://github.com/rainlabs/mina-mercurial)
* [mina-faye](https://github.com/NingenUA/mina-faye)
* [mina-clockwork](https://github.com/907th/mina-clockwork)
* [mina-ftp](https://github.com/stas/mina-ftp)
* [mina-laravel](https://github.com/kikyous/mina-laravel)

Acknowledgements
----------------

© 2012-2015, Nadarei. Released under the [MIT License](http://www.opensource.org/licenses/mit-license.php).

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
[c]:   http://github.com/mina-deploy/mina/graphs/contributors
[nd]:  http://nadarei.co
[issues]: https://github.com/mina-deploy/mina/issues
[trello]: https://trello.com/board/mina/4fc8b3023d9c9a4d72e573e6

