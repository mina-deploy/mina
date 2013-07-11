# Mina

Really fast deployer and server automation tool.

Mina works really fast because it's a deploy Bash script generator. It
generates an entire procedure as a Bash script and runs it remotely in the
server.

Compare this to the likes of Vlad or Capistrano, where each command
is ran separately on their own SSH sessions. Mina only creates *one* SSH
session per deploy, minimizing the SSH connection overhead.

    $ gem install mina
    $ mina

[![Status](https://secure.travis-ci.org/nadarei/mina.png?branch=master)](http://travis-ci.org/nadarei/mina) [![Version](https://badge.fury.io/rb/mina.png)](http://badge.fury.io/rb/mina)


# Helpers

### invoke
Invokes another Rake task.

Invokes the task given in `task`. Returns nothing.

    invoke :'git:clone'
    invoke :restart

Options:
  reenable (bool) - Execute the task even next time.

### erb
Evaluates an ERB block in the current scope and returns a string.

    a = 1
    b = 2

    # Assuming foo.erb is <%= a %> and <%= b %>
    puts erb('foo.erb')

    #=> "1 and 2"

Returns the output string of the ERB template.

### run!
SSHs into the host and runs the code that has been queued.

This is already automatically invoked before Rake exits to run all
commands that have been queued up.

    queue "sudo restart"
    run!

Returns nothing.

### report_time
Report time elapsed in the block.
Returns the output of the block.

    report_time do
      sleep 2
      # do other things
    end

    # Output:
    # Elapsed time: 2.0 seconds

### measure
Measures the time (in ms) a block takes.
Returns a [time, output] tuple.

### mina_cleanup
__Internal:__ Invoked when Rake exits.

Returns nothing.

## Errors

### die
Exits with a nice looking message.
Returns nothing.

    die 2
    die 2, "Tests failed"

### error
__Internal:__ Prints to stdout.
Consider using `print_error` instead.

## Queueing

### queue
Queues code to be ran.

This queues code to be ran to the current code bucket (defaults to `:default`).
To get the things that have been queued, use commands[:default]

Returns nothing.

    queue "sudo restart"
    queue "true"

    commands == ['sudo restart', 'true']

### queue!
Shortcut for `queue`ing a command that shows up in verbose mode.

### echo_cmd
Converts a bash command to a command that echoes before execution.
Used to show commands in verbose mode. This does nothing unless verbose mode is on.

Returns a string of the compound bash command, typically in the format of
`echo xx && xx`. However, if `verbose_mode?` is false, it returns the
input string unharmed.

    echo_cmd("ln -nfs releases/2 current")
    #=> echo "$ ln -nfs releases/2 current" && ln -nfs releases/2 current

## Commands

### commands
Returns an array of queued code strings.

You may give an optional `aspect`.

Returns an array of strings.

    queue "sudo restart"
    queue "true"

    to :clean do
      queue "rm"
    end

    commands == ["sudo restart", "true"]
    commands(:clean) == ["rm"]

### isolate
Starts a new block where new `commands` are collected.

Returns nothing.

    queue "sudo restart"
    queue "true"
    commands.should == ['sudo restart', 'true']

    isolate do
      queue "reload"
      commands.should == ['reload']
    end

    commands.should == ['sudo restart', 'true']

### in_directory
Starts a new block where #commands are collected, to be executed inside `path`.

Returns nothing.

  in_directory './webapp' do
    queue "./reload"
  end

  commands.should == ['cd ./webapp && (./reload && true)']

Defines instructions on how to do a certain thing.
This makes the commands that are `queue`d go into a different bucket in commands.

Returns nothing.

    to :prepare do
      run "bundle install"
    end
    to :launch do
      run "nginx -s restart"
    end

    commands(:prepare) == ["bundle install"]
    commands(:restart) == ["nginx -s restart"]

## Settings helpers

### set
Sets settings.
Sets given symbol `key` to value in `value`.

Returns the value.

    set :domain, 'kickflip.me'

### set_default
Sets default settings.
Sets given symbol `key` to value in `value` only if the key isn't set yet.

Returns the value.

    set_default :term_mode, :pretty
    set :term_mode, :system
    settings.term_mode.should == :system

    set :term_mode, :system
    set_default :term_mode, :pretty
    settings.term_mode.should == :system

### settings
Accesses the settings hash.

    set :domain, 'kickflip.me'

    settings.domain  #=> 'kickflip.me'
    domain           #=> 'kickflip.me'

### method_missing
Hook to get settings.
See #settings for an explanation.

Returns things.

## Command line mode helpers

### verbose_mode?
Checks if Rake was invoked with --verbose.

Returns true or false.

### simulate_mode?
Checks if Rake was invoked with --simulate.

Returns true or false.

## Internal helpers

### indent
Indents a given code block with `count` spaces before it.

### unindent
__Internal:__ Normalizes indentation on a given string.

Returns the normalized string without extraneous indentation.

    puts unindent %{
      Hello
        There
    }
    # Output:
    # Hello
    #   There

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

    script = deploy_script do
      invoke :'git:checkout'
    end

    queue script

Returns the deploy script as a string, ready for `queue`ing.

# Modules: Bundler
Adds settings and tasks for managing Ruby Bundler.

    require 'mina/bundler'

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### bundle_bin
Sets the bundle path.

### bundle_path
Sets the path to where the gems are expected to be.

This path will be symlinked to `./shared/bundle` so that the gems cache will
be shared between all releases.

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

## Tasks
Any and all of these settings can be overriden in your `deploy.rb`.

### environment
Make the `:environment` task exist by default. This is meant to be overridden
by users.

### init
Initializes a new Mina project.

    $ mina init

### help
Shows the help screen.

### tasks
Display all tasks in a nice table.

    $ mina tasks

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

    $ mina deploy:force_unlock

You can also combine that task with `deploy`:

    $ mina deploy:force_unlock deploy

### deploy:link_shared_paths
Links the shared paths in the `shared_paths` setting.

### deploy:cleanup
Cleans up old releases.

By default, the last 5 releases are kept on each server (though you can
change this with the keep_releases setting).  All other deployed revisions
are removed from the servers."

### setup
Sets up a site's directory structure.

### run[]
Runs a command on a server.

    $ mina run[tail -f logs.txt]

# Modules: Foreman
Adds settings and tasks for managing projects with [foreman].

NOTE: Requires sudo privileges

[foreman]: http://rubygems.org/ddolar/foreman

   require 'mina/foreman'

## Common usage

   set :application, "app-name"

   task :deploy => :environment do
     deploy do
       # ...
       invoke 'foreman:export'
       # ...
     end

     to :launch do
       invoke 'foreman:restart'
     end
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

    require 'mina/git'

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### branch
Sets the branch to be deployed.

## Deploy tasks
These tasks are meant to be invoked inside deploy scripts, not invoked on
their own.

### git:clone
Clones the Git repository. Meant to be used inside a deploy script.

# Modules: Rails
Adds settings and tasks for managing Rails projects.

    require 'mina/rails'

## Settings
Any and all of these settings can be overriden in your `deploy.rb`.

### rails_env
Sets the Rails environment for `rake` and `rails` commands.

Note that changing this will NOT change the environment that your application
is ran in.

### bundle_prefix
Prefix for Bundler commands. Often to something like `RAILS_ENV=production
bundle exec`.

    queue! "#{bundle_prefix} annotate -r"

### rake
The prefix for `rake` commands. Use like so:

    queue! "#{rake} db:migrate"

### rails
The prefix for `rails` commands. Use like so:

    queue! "#{rails} console"

### asset_paths
The paths to be checked.

Whenever assets are compiled, the asset files are checked if they have
changed from the previous release.

If they're unchanged, compiled assets will simply be copied over to the new
release.

Override this if you have custom asset paths declared in your Rails's
`config.assets.paths` setting.

### rake_assets_precompile
The command to invoke when precompiling assets.
Override me if you like.

----

Macro used later by :rails, :rake, etc

## Command-line tasks
These tasks can be invoked in the command line.

### rails[]
Invokes a rails command.

    $ mina rails[console]

### rake[]
Invokes a rake command.

    $ mina rake db:cleanup

### console
Opens the Ruby console for the currently-deployed version.

   $ mina console

## Deploy tasks
These tasks are meant to be invoked inside deploy scripts, not invoked on
their own.

### rails:db_migrate

### rails:db_migrate:force

### rails:assets_precompile:force

### rails:assets_precompile

# Modules: rbenv
Adds settings and tasks for managing [rbenv] installations.

[rbenv]: https://github.com/sstephenson/rbenv

    require 'mina/rbenv'

## Common usage

    task :environment do
      invoke :'rbenv:load'
    end

    task :deploy => :environment do
      ...
    end

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

    require 'mina/rvm'

## Common usage

    task :environment do
      invoke :'rvm:use[ruby-1.9.3-p125@gemset_name]'
    end

    task :deploy => :environment do
      ...
    end

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

    task :environment do
      invoke :'rvm:use[ruby-1.9.3-p125@gemset_name]'
    end

### rvm:wrapper[]
Creates a rvm wrapper for a given executable

This is usually placed in the `:setup` task.

    task ::setup => :environment do
      ...
      invoke :'rvm:wrapper[ruby-1.9.3-p125@gemset_name,wrapper_name,binary_name]'
    end

Adds settings and tasks for managing projects with [whenever].
[whenever]: http://rubygems.org/gems/whenever

Acknowledgements
----------------

© 2012-2013, Nadarei. Released under the [MIT 
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

