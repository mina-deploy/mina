# Frequently Asked Questions

## - `command not found: bundle`

You need to setup your server correctly [getting started](getting_started.md#step-0-configure-server), then install bundler.

    gem install bundler

## - `my_program` not found, but is already installed

Mina is running in a non-interactive ssh mode. That means that your full profile will not be loaded:  ![ssh](http://capistranorb.com/images/BashStartupFiles1.png)

There is a line at the top in most `.bashrc` files:
```
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
```
this means that all lines below this will not be executed when using mina.

The easiest way to fix this is to move all your `export` and `source` lines to the top of your `.bashrc` file.
More info at: http://stackoverflow.com/a/216204/1339894

## - Mina hangs after i type my password in

Mina assumes that you have set up the communication with your server through the public/private keys, not password. If you want to use the password you will have to change the execution mode:

    set :execution_mode, :system

# WIP
