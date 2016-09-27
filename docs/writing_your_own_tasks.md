Writing your own tasks
--------------------

# Defining tasks

The file `deploy.rb` is simply a Rakefile invoked by Rake. In fact, `mina` is
mostly an alias that invokes Rake to load `deploy.rb`.

``` ruby
# Sample config/deploy.rb
set :domain, 'your.server.com'

task :restart do
  comment 'Restart application'
  command "passenger-config restart-app --ignore-app-not-running #{deploy_to}"
end
```

As it's all Rake, you can define tasks that you can invoke using `mina`. In this
example, it provides the `mina restart` command.

The magic of Mina is in the new commands it gives you.

The `command` command queues up Bash commands to be run on the remote server.
If you invoke `mina restart`, it will invoke the task above and run the queued
commands on the remote server `your.server.com` via SSH.

# DSL

## Helpers

### invoke
Invokes another Rake task.

``` ruby
invoke :'git:clone'
invoke :restart
```

### command
Adds a command to the command queue.

This queues code to be run on the current queue name (defaults to `:default`).

By default, whitespace is stripped from the beginning and end of the command.

``` ruby
command %{ls -al} # => [ls -al]
```

### comment
Adds a comment to the command queue.

``` ruby
comment %{ls -al} # => [echo "-----> ls -al"]
```

### run
Runs the given block on the defined backend (remote or local)

``` ruby
run :remote do
  command %{ls -al}
end
```

### on
Change the queue name for the given block. Use this if you have multiple places where commands need to end up. Mainly used in `deploy` task.

``` ruby
on :launch do
  invoke :restart
end
```

### in_path
Change the path the commands in the given block is run.

``` ruby
in_path('some/new/path') do
  command %{ls -al} # => cd some/new/path && ls -al
end
```

## Configuration

### set
Sets configuration variable. Can a value or a proc/lambda.

``` ruby
set :deploy_to -> '/path/to/deploy'
```

### fetch
Gets configuration variable. Runs `.call` if callable.
Returns nil if not set. If default parameter is passed returns default if not set.

``` ruby
fetch(:deploy_to)
fetch(:deploy_to, 'some_default')
```

### set?
Checks if a variable is set.

``` ruby
set?(:deploy_to)
```

### ensure!
Raises an error if variable is not set

``` ruby
ensure!(:deploy_to)
```
