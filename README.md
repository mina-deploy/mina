Van Helsing
===========

Deployer!

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

    $ cat config/deploy.rb

    set :host, 'flipstack.com'
    set :user, 'flipstack'
    set :deploy_to, '/var/www/flipstack.com'

    task :deploy do
      deploy do
        # Put things that prepare here.
        invoke :'git:checkout'
        invoke :'bundle:install'

        to :restart do
          run 'touch tmp/restart.txt'
        end
      end

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

