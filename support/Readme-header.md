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
