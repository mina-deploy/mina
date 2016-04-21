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
