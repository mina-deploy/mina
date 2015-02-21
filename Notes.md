Readme
------

The readme file is auto-generated using make.

    $ make Readme.md

Documentation
-------------

Please consult the [project documentation](http://mina-deploy.github.io/mina) for full
details.

Problems or suggestions? File issues at the [issue tracker][issues].

Documentation sources
---------------------

See [mina-deploy/mina-docs](https://github.com/mina-deploy/mina-docs) for the sources of
the documentation site. Please ensure that docs there are in sync with the
features here.

Development & testing
---------------------

To test out stuff in development:

``` sh
# Run specs
$ rspec
$ rspec -t ssh     # Run SSH tests (read test_env/config/deploy.rb first)
$ rake=10 rspec
$ rake=0.9 rspec
$ rake=0.8 rspec

# Alias your 'mina' to use it everywhere
$ alias mina="`pwd -LP`/bin/mina"
```

### Doing test deploys

Try out the test environment:

``` sh
$ cd test_env
$ mina deploy --simulate
$ mina deploy

# There's an rspec task for it too
$ rspec -t ssh
```

### Gem management

``` sh
# To release the gem:
# Install the Git changelog helper: https://gist.github.com/2880525
# Then:

$ vim lib/mina/version.rb
$ git clog -w
$ vim HISTORY.md
$ git commit -m "Release v0.8.4."
$ rake release

# Please don't forget to tag the release in github.com/nadarei/mina-docs too!

$ rake build      # Builds the gem file
$ rake install    # Installs the gem locally
```
