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

    $ cd test_env
    $ ../bin/vh deploy simulate=1
    $ ../bin/vh deploy


Setting up
----------

### 1. Create a config/deploy.rb.

In your project, type `vh init` to create a sample of this file.

This is just a Rake file with tasks!

    $ vh init
    Created config/deploy.rb.

### 2. Set up your server.

Make a directory in your server called `/var/www/flipstack.com` (in *deploy_to*)
change it's ownership to the user `flipstack`.

Now do `vh setup` to set up the folder structure in this path. This will connect
to your server via SSH and create the right directories.

    $ vh setup
    -----> Creating folders... done.

    $ ssh flipstack@flipstack.com -- ls /var/www/flipstack.com
    releases
    shared

### 3. Deploy!

Use `vh deploy` to run the `deploy` task defined in config/deploy.rb.

    $ vh deploy
    -----> Deploying to 2012-06-12--04-02-48
           ...
           Lots of things happening...
           ...
    -----> Done.


About deploy.rb
---------------

The file `deploy.rb` is simply a Rakefile invoked by Rake. In fact, `vh` is
mostly an alias that invokes Rake to load `deploy.rb`.

Here's a sample file:

``` ruby
set :host, 'your.server.com'

task :restart do
  queue 'sudo service restart apache'
end
```

The magic of Van Helsing is in the new commands it gives you.

The `queue` command queues up Bash commands to be ran on the remote server.
If you invoke `vh restart`, it will invoke the task above and run the queued
commands on the remote server `your.server.com` via SSH.

### Subtasks

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

### Deploying

Van Helsing provides the `deploy` command which `queue`s up a deploy script for
you.

``` ruby
set :host, 'flipstack.com'
set :user, 'flipstack'
set :deploy_to, '/var/www/flipstack.com'

task :deploy do
  deploy do
    # Put things that prepare here.
    # Commands queued here will be ran on a new release directory.
    invoke :'git:checkout'
    invoke :'bundle:install'

    to :restart do
      run 'touch tmp/restart.txt'
    end
  end
end
```

How deploying works
-------------------

The deploy process looks like this:

1. Decide on a release name based on the current timestamp, say,
   `2012-06-02--04-58-23`.
2. cd to `/var/www/flipstack.com` (the *deploy_to* path).
3. Create `./releases/2012-06-02--04-58-23` (the *release path*).
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
     '-  current/               # A symlink to the current release in releases/

It also assumes that the `deploy_to` path is fully writeable/readable for the
user we're going to SSH with.
