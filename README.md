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

Documentation
-------------

Please consult the [project documentation](http://nadarei.co/mina) for full
details.

Problems or suggestions? File issues at the [issue tracker][issues]
(github.com).  You may also look at the [Trello board][trello] (trello.com) we
use for development.

Documentation sources
---------------------

See [nadarei/mina-docs](https://github.com/nadarei/mina-docs) for the sources of
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

