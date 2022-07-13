## Ry Tasks

> **Warning**
> Ry tasks will be removed in version 2.0.0. To continue using ry tasks, install [mina-version_managers](https://github.com/mina-deploy/mina-version_managers).

Tasks for [ry](https://github.com/jneen/ry) commands.

Load the tasks by adding:
```ruby
# config/deploy.rb
require 'mina/ry'
```

## Variables

These tasks use the following variable.

### `:ry_path`

Specifies the path to ry installation (see [ry documentation](https://github.com/jneen/ry#installation)).

Value: `$HOME/.local`

## Tasks

### `ry`

Adds `:ry_path/bin` path to the `PATH` environment variable, invokes `ry setup`, and then sets the Ruby version, which can be provided as an argument. If you don't provide an argument, the default Ruby version will be used.

Example:
```ruby
# config/deploy.rb
task :deploy do
  invoke :ry, '3.0.0' # sets Ruby version to 3.0.0, omit if you want the default version
end
```
