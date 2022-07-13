## Rbenv Tasks

> **Warning**
> Rbenv tasks will be removed in version 2.0.0. To continue using rbenv tasks, install [mina-version_managers](https://github.com/mina-deploy/mina-version_managers).

Tasks for [rbenv](https://github.com/rbenv/rbenv) commands.

Load the tasks by adding:
```ruby
# config/deploy.rb
require 'mina/rbenv'
```

## Variables

These tasks use the following variable.

### `:rbenv_path`

Path to the `.rbenv` directory on the server.

Default value: `$HOME/.rbenv`

## Tasks

### `rbenv:load`

Adds rbenv binary path (`:rbenv_path/bin`) to the `PATH` environment variable, and executes [`rbenv init`](https://github.com/rbenv/rbenv#how-rbenv-hooks-into-your-shell).

Example:
```ruby
# config/deploy.rb
task :deploy do
  invoke 'rbenv:load'
end
```
