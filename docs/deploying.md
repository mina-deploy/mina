Deploying
--------------------

Mina provides the `deploy` command which runs your commands on remote backend.

``` ruby
# config/deploy.rb
set :domain, 'flipstack.com'
set :user, 'flipstack'
set :deploy_to, '/var/www/flipstack.com'
set :repository, 'https://github.com/flipstack/flipstack.git'

task :deploy do
  deploy do
    # Put things that prepare the empty release folder here.
    # Commands queued here will be run on a new release directory.
    invoke :'git:clone'
    invoke :'bundle:install'

    # These are instructions to start the app after it's been prepared.
    on :launch do
      command %{touch tmp/restart.txt}
    end

    # This optional block defines how a broken release should be cleaned up.
    on :clean do
      command %{log "failed deployment"}
    end
  end
end
```

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

Once the project has been built, it will be moved to `releases/`.
Invoke the commands queued up in the `on :build` block.

    $
    -----> Moving to releases/4
           $ mv "./tmp/build-128293482394" "releases/4"
    -----> Symlinking to current
           $ ln -nfs releases/4 current

### Step 3: Launch it

A symlink called `current/` will be created to point to the active release.
Invoke the commands queued up in the `on :launch` block. These often
commands to restart the webserver process. Once this in complete, you're done!

    $
    -----> Launching
           $ cd releases/4
           $ sudo service nginx restart
    -----> Done. Deployed v4

### What about failure?

If it fails at any point, the release path will be deleted. If any commands are
queued using the `on :clean` block, they will be run. It will be as if nothing
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
