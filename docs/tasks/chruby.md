## Chruby Tasks

> **Warning**
> Chruby tasks will be removed in version 2.0.0. To continue using chruby tasks, install [mina-version_managers](https://github.com/mina-deploy/mina-version_managers).

Tasks for [chruby](https://github.com/postmodern/chruby) commands.

Load the tasks by adding:
```ruby
# config/deploy.rb
require 'mina/chruby'
```

## Variables

These tasks use the following variable.

### `:chruby_path`

Specifies the path to chruby script (see [chruby documentation](https://github.com/postmodern/chruby#configuration)).

Default value: `/etc/profile.d/chruby.sh`

## Tasks

### `chruby`

Loads chruby environment from [`:chruby_path`](#chrubypath) and sets the Ruby version, which is provided as an argument.

Example:
```ruby
# config/deploy.rb
task :deploy do
  invoke :chruby, '3.0.0' # sets Ruby version to 3.0.0
end
```
