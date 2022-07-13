# CLI Options

Mina supports most of Rake's [command-line options](https://ruby.github.io/rake/doc/command_line_usage_rdoc.html) (all except `quiet`, `silent` and `dry-run`). In addition to Rake's options, Mina adds a couple of its own:

## `--verbose` (`-v`)

Print a command before executing it. Use this option if you want to see what will be executed, right before it's executed.

Example:
```ruby
# config/deploy.rb

task :example do
  run(:local) do
    command "echo Hello world"
  end
end
```

If you run `mina example`, the following is output:
```bash
Hello world
```

And if you run `mina example --verbose`, the output becomes:
```
$ echo Hello world
Hello world
```

## `--simulate` (`-s`)

Print all commands without executing them (dry run).

Example:
```ruby
# config/deploy.rb

task :example do
  run(:local) do
    command "echo Hello world"
  end
end
```

If you run `mina example --simulate`, it will output:
```bash
#!/usr/bin/env bash
# Executing the following:
#
echo Hello world
```

## `--debug-configuration-variables` (`-d`)

Print values of all variables.

Example output:
```bash
========== Configuration variables ==========
:debug_configuration_variables => true
:port => 22
:execution_mode => :pretty
========== Configuration variables ==========
```

## `--no-report-time`

Don't print execution time. By default, Mina prints the time it took for a task to execute. This flag suppresses that.
