## RVM Tasks

> **Warning**
> RVM tasks will be removed in version 2.0.0. To continue using RVM tasks, install [mina-version_managers](https://github.com/mina-deploy/mina-version_managers).

Tasks for [RVM](https://github.com/rvm/rvm) commands.

Load the tasks by adding:
```ruby
# config/deploy.rb
require 'mina/rvm'
```

## Variables

These tasks use the following variable.

### `:rvm_use_path`

Specifies the path to the RVM [install script](https://rvm.io/rvm/install#installation).

Default value: `$HOME/.rvm/scripts/rvm`

## Tasks

### `rvm:use`

Loads RVM from [`:rvm_use_path`](#rvmusepath) and sets current Ruby version, which is provided as an argument.

```ruby
# config/deploy.rb

task :deploy do
  deploy do
    invoke 'rvm:use', '3.0.0' # loads RVM and sets current Ruby version to 3.0.0
  end
end
```

### `rvm:wrapper`

Creates an RVM wrapper for the given environment and binary.

Example:
```ruby
# config/deploy.rb

task :deploy do
  deploy do
    # creates a wrapper called `myapp` for the binary `unicorn_rails` in the environment `3.0.0`
    invoke 'rvm:wrapper', '3.0.0', 'myapp', 'unicorn_rails'
  end
end
```
