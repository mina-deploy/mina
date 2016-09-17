Frequently Asked Questions
--------------------

* `command not found: bundle`

You need to setup your server correctly [getting started](getting_started.md#step-0-configure-server), then install bundler.

    gem install bundler

* `ruby version not found, but is already installed`

Mina is running in a non-interactive ssh mode. That means that your full profile will not be loaded:  ![ssh](http://capistranorb.com/images/BashStartupFiles1.png)

if you setup your server correctly and you are using a ruby environment manager please ensure that:
  - you are using a mina plugin for that manager or
  - the lines that load up your manager are at the top of your .bashrc file: http://stackoverflow.com/a/216204/1339894

# WIP
