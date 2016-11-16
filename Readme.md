# Mina

[![Code Climate](https://codeclimate.com/github/mina-deploy/mina/badges/gpa.svg)](https://codeclimate.com/github/mina-deploy/mina)
[![Test Coverage](https://codeclimate.com/github/mina-deploy/mina/badges/coverage.svg)](https://codeclimate.com/github/mina-deploy/mina/coverage)
[![Build Status](https://semaphoreci.com/api/v1/d4be4st/mina/branches/master/shields_badge.svg)](https://semaphoreci.com/d4be4st/mina)
[![Gem Version](https://badge.fury.io/rb/mina.svg)](https://badge.fury.io/rb/mina)

![mina](https://assets.infinum.co/attachments/ad98b5e667facece8bb0b790f3cafe5bcb2dc469/store/limit/1000/1000/291724d19624f688957cebb5a0549abb6ea07113bdac11026ad2d5a6d29f/Mina_Icon.png)

Really fast deployer and server automation tool.

## Warning

**This is a readme of the current master, version 1.0.0. If you are using older mina (pre 0.3) please take a look at [0.3 readme](https://github.com/mina-deploy/mina/blob/v0.3.8/Readme.md)**


Mina works really fast because it's a deploy Bash script generator. It
generates an entire procedure as a Bash script and runs it remotely in the
server.

Compare this to the likes of [Capistrano](https://github.com/capistrano/capistrano), where it opens an SSH connection and runs each command in sequence
, Mina only creates a SSH session and sends *one* command.

    $ gem install mina
    $ mina init

Mina requires ruby 2.0.0 or greater. For older please use [0.3.8 version](https://github.com/mina-deploy/mina/blob/v0.3.8/)

Documentation
----------------

For quick start check out [Getting starting guide](docs/getting_started.md)

For migrating your current 0.3.x deploy scripts, please look at the [migrating guide](docs/migrating.md)

For FAQ please visit the [faq](docs/faq.md)

If you are missing some plugins check the [3rd party plugins doc](docs/3rd_party_plugins.md)

For other documentation please visit the [docs](docs)

Licence
----------------

Released under the [MIT License](https://www.opensource.org/licenses/mit-license.php).

Credits
----------------

Mina is maintained and sponsored by [Infinum](https://infinum.co).

You can reach us on twitter [Stef](https://twitter.com/_Beast_) & [Infinum](https://twitter.com/infinumco)

![](https://assets.infinum.co/assets/brand-logo-9e079bfa1875e17c8c1f71d1fee49cf0.svg) © 2016 Infinum.  
