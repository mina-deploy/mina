# Execution Modes

An execution mode defines the means Mina uses to run a task and how the output is formatted.

Overview of available execution modes:
Mode       | Stdin enabled | Formatted stdout | Executes commands |
-----------|---------------|------------------|-------------------|
`:pretty`  | ❌            | ✅                | ✅                |
`:exec`    | ✅            | ❌                | ✅                |
`:system`  | ✅            | ❌                | ✅                |
`:printer` | ✅            | ❌                | ❌                |

Execution mode can be changed by setting the `:execution_mode` variable:
```ruby
# config/deploy.rb
set :execution_mode, :exec
```

## :pretty

Runs the script by calling [`Open3.popen3`](https://docs.ruby-lang.org/en/3.0/Open3.html#method-c-popen3).

Stdout and stderr are pretty-printed (lines are colorized and indented).

Stdin is **disabled**, so any kind of input won't be forwarded to the server. In case you need stdin, use either [`:system`](#system) or [`:exec`](#exec).

The majority of built-in tasks use this mode. 

## :exec

Runs the script by calling [`Kernel#exec`](https://docs.ruby-lang.org/en/3.0/Kernel.html#method-i-exec).

Stdout and stderr are displayed as-is, no pretty-printing is applied. You can use stdin.

This execution mode runs the task and exits the program.

## :system

Runs the script by calling [`Kernel#system`](https://docs.ruby-lang.org/en/3.0/Kernel.html#method-i-system).

Stdout and stderr are displayed as-is, no pretty-printing is applied. You can use stdin.

This execution mode runs the task in a subshell.

## :printer

Prints the script with [`Kernel#puts`](https://docs.ruby-lang.org/en/3.0/Kernel.html#method-i-puts), so the script isn't executed but just displayed.

This execution mode is used when you invoke Mina with the [`--simulate`](./cli_options.md#simulate--s) option.
