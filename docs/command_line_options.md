Command line options
--------------------

Basic usage:

    $ mina [OPTIONS] [TASKS] [VAR1=val VAR2=val ...]

### Options

Beside normal rake options mina added some of its own:

* `-v` / `--verbose` - This will show commands being done on the server. Off by
  default.

* `-s` / `--simulate` - This will not run any commands; instead, it will simply output the script it builds.

* `-V` / `--version` - Shows the current version.

* `-d` / `--debug-configuration-variables` - Display the defined config variables before runnig the tasks.

### Tasks

There are many tasks available. See the [tasks reference](https://mina-deploy.github.io/mina/tasks/), or
type `mina -T`.

### Variables

You may specify additional variables in the `KEY=value` style, just like any other command line tools.
You can add as many variables as needed.

    $ mina restart on=staging

    # This sets the ENV['on'] variable to 'staging'.
