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

