# Bundler Tasks

Tasks for [Bundler](https://bundler.io/) commands.

Load the tasks by adding:
```ruby
# config/deploy.rb
require 'mina/bundler'
```

The above will also load [`default`](./default) tasks.

## Variables

These tasks use the following variables.

### `:bundle_bin`

Specifies the bundler binary used by all tasks. Override this if you'd like to use a different bundler binary.

Default value: `bundle`

### `:bundle_path`

Specifies the path where `bundle install` will install gems.

Default value: `vendor/bundle`

### `:bundle_withouts`

Specifies which [Gemfile groups](https://bundler.io/guides/groups.html) won't be installed. Groups should be provided as a space-separated list.

Default value: `development test`

### `:bundle_options`

[Options](https://bundler.io/man/bundle-install.1.html#OPTIONS) passed to the `bundle install` command.

Default value: `-> { %(--without #{fetch(:bundle_withouts)} --path "#{fetch(:bundle_path)}" --deployment) }`<br />
Example: `--without development test --path "vendor/bundle" --deployment`

### `:shared_dirs`

Defines directories which will be shared between releases (see docs for the [`deploy:link_shared_paths`](./deploy.md#deploylinksharedpaths) task).

The default value appends [`:bundle_path`](#bundlepath) to existing shared directories, meaning Mina will cache gems between releases.

Default value: `fetch(:shared_dirs, []).push(fetch(:bundle_path))`

## Tasks

### `bundle:install`

Runs [`bundle install`](https://bundler.io/v2.3/man/bundle-install.1.html) with options defined by the [`:bundle_options`](#bundleoptions) variable.

Example:
```ruby
# config/deploy.rb
task :deploy do
  invoke 'bundle:install'
end
```

### `bundle:clean`

Runs [`bundle clean`](https://bundler.io/v2.3/man/bundle-clean.1.html).

Example:
```ruby
# config/deploy.rb
task :deploy do
  invoke 'bundle:clean'
end
```
