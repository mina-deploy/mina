Setting up a project
--------------------

Let's deploy a project using Mina.

### Step 0: Configure server

Your server needs to be properly configured for mina to work. Requirements for mina 1.0 to work:
- SSH public/private key pair set up
- deploy user to have access to folders where you want to install the application
- installed git
- installed ruby (some ruby manager recommended rbenv/rvm/chruby)
- installed bundler

### Step 1: Create a config/deploy.rb

In your project, type `mina init` to create a sample of this file.

    $ mina init
    Created config/deploy.rb.

This is just a Rake file with tasks! See [How to write your own tasks](writing_your_own_tasks.md) for
more info on what *deploy.rb* is. You will want to at least configure your
server:

``` ruby
# config/deploy.rb
set :user, 'username'
set :domain, 'your.server.com'
set :deploy_to, '/var/www/flipstack.com'
...
```

### Step 2: Run 'mina setup'

Back at your computer, do `mina setup` to set up the folder structure in `deploy_to` path.
This will connect to your server via SSH and create the right directories.

    $ mina setup
    -----> Creating folders... done.

See [directory structure](https://github.com/mina-deploy/mina/wiki/Directory-structure) for more info.

### Step 3: Deploy!

Use `mina deploy` to run the `deploy` task defined in *config/deploy.rb*.

    $ mina deploy
    -----> Deploying to 2012-06-12-040248
           ...
           Lots of things happening...
           ...
    -----> Done.
