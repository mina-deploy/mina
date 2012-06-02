Bundler
=======

To manage Rails project installations, add this to your `deploy.rb`:

``` ruby
require 'van_helsing/rails'
```

Settings
--------

This introduces the following settings. All of them are optional.

 * __rake__  
 The `rake` command. Defaults to `RAILS_ENV="#{rails_env}" bundle exec rake`.

 * __rails_env__  
 Defaults to `production`.

Tasks
-----

Adds the following tasks:

### rails:db_migrate

Invokes rake to migrate the database using `rake db:migrate`.

### rails:assets_precompile

Precompiles assets. This invokes `rake assets:precomplie`.

It also checks the current version to see if it has assets compiled. If it does,
it reuses them, skipping the compilation step. To stop this behavior, invoke
the `vh` command with `force_assets=1`.

### rails:assets_precompile:force

Precompiles assets. This always skips the "reuse old assets if possible" step.


