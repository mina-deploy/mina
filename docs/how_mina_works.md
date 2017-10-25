# How Mina Works?

## The Idea

The idea behind `mina` is to have one (or more) config file which contains all the information about your server. Domain info, deploy user info, where will your application live, etc.
With that information `mina` creates a bash script that deploys your application. `mina` connects to your server over ssh and runs the generated bash script.

Example of generated deploy script

``` sh
$ mina deploy
#!/usr/bin/env bash
# Executing the following via 'ssh deploy@example.com -p 22 -tt':
#
#!/usr/bin/env bash

# Go to the deploy path
...

# Checks
...

# Bootstrap script (in deployer)
  echo "-----> Creating a temporary build path"
  touch "deploy.lock" &&
  mkdir -p "$build_path" &&
  cd "$build_path" &&
  ...
  echo "-----> Deploy finished"
#
# Build
  echo "-----> Building"
  ...
#
# Launching
# Rename to the real release path, then symlink 'current'
  echo "-----> Launching"
  ...

# ============================
# === Start up server => (in deployer)
  ...

# ============================
# === Complete & unlock
  rm -f "deploy.lock"
  echo "-----> Done. Deployed version $version"

# ============================
# === Failed deployment
  echo "! ERROR: Deploy failed."
  ...

# Unlock
  rm -f "deploy.lock"
  echo "OK"
  exit 19
)


Elapsed time: 0.00 seconds

```

This script is then run on your server over ssh. Example:

```
ssh deploy@example.com -p 22 -tt --- "#!/usr/bin/env/bash\n #Go to the deploy path\n ...."
```

## The CLI

Basic usage:

    $ mina [OPTIONS] [TASKS] [VAR1=val VAR2=val ...]

### Options

Beside normal rake options mina added some of its own:

* `-v` / `--verbose` - This will show commands being done on the server. Off by
  default.

* `-s` / `--simulate` - This will not run any commands; instead, it will simply output the script it builds.

* `-V` / `--version` - Shows the current version.

* `-AT` / `--all --tasks` - Show all tasks mina can run.

* `-d` / `--debug-configuration-variables` - Display the defined config variables before runnig the tasks.

### Tasks

A cool feautre of rake is that you run multiple tasks from one command:

```
  $ mina setup deploy
```

This command will run both `setup` and `deploy` task consecutively.

### Variables

You may specify additional variables in the `KEY=value` style, just like any other command line tools.
You can add as many variables as needed.

    $ mina restart on=staging

    # This sets the ENV['on'] variable to 'staging'.


## Folder Structure

After `mina setup` is run, you can see this structure on your server:

``` sh
.
├── current -> /home/deploy/www/example.com/releases/91
├── releases
│   ├── 86
│   ├── 87
│   ├── 88
│   ├── 89
│   ├── 90
│   └── 91
├── scm
├── shared
│   ├── bundle
│   ├── config
│   ├── log
│   ├── public
│   ├── tmp
│   └── vendor
└── tmp
```

Folder | Description
-------|------
`current` | folders is a symbolic link to the current release (does not have to be the lastest one)
`releases` | folder conains your last `keep_releases` releases
`scm` | folder contains information about your version controll (git, svn, ...)
`shared` | folder cotinas folders and files that are kept between releaes (logs, uploads, configs, ...)
`tmp` | folder contains temporary build folders

## Features

### Execution modes (Runners)

With `set :execution_mode` you can change how your tasks are run. There are currently 4 modes:

Mode | Description
-----|------------
`:exec` | It uses [Kernel#exec](http://ruby-doc.org/core-2.4.2/Kernel.html#method-i-exec) to run your script. This means that it will execute and exit and won't run any other tasks. This is useful for tasks such as [`mina console`](https://github.com/mina-deploy/mina/blob/master/tasks/mina/rails.rb#L15)
`:system` | It uses [Kernel#system](http://ruby-doc.org/core-2.4.2/Kernel.html#method-i-system) to run your script.
`:pretty` | It uses [Open4#popen4](https://github.com/ahoward/open4/blob/master/lib/open4.rb#L33) to run your script. This mode pretty prints stdout and stderr and colors it. This the default mode for most of the default tasks.
`:printer` | It uses [Kernel#puts](http://ruby-doc.org/core-2.4.2/Kernel.html#method-i-puts) to run your script. This is used when `simulate` flag is set so it only prints out the generated script

#### WARNING
`:pretty` mode is using Popen4. In this mode STDIN is efectivly disabled. This means that any kind of inputs won't be forwarded to remote host. If you have a need for password input please use `:system` mode

### Backends

When writing your tasks you can choose on which backend you want your scripts to run. Currently there are 2 backends:

Backend | Description
--------|---------
`:remote` | Run on your server over SSH (Default)
`:local` | Run on your machine

Choosing on which backend a particular block is ran is defined in [`run(backend) do` block](writing_your_own_tasks.rb#run)
These `run` blocks can be used however you want, you can mixandmatch them anywhich way. Only restriction is thay you can't use a `run` block inside another `run` block.

Example:

```
task :example do
  run(:local) do
    comamnd "scp config/application.yml #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/application.yml"
  end

  run(:remote) do
    command "passenger-configure restart-app"
  end

  run(:local) do
    command 'say "Done!"'
  end
end
```

`deploy do` block is a wrapper around `run(:backend) do` block.

If a tasks is created without a `run do` block, `:remote` backend is assumed:

``` ruby
task :example do
  command "passenger-configure restart-app"
end
```

The above command will be run on your server.

