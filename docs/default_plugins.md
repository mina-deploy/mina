# Default Plugins

`mina` comes with a variaty of plugins for you to use out of the box. As `mina` is primarely written in ruby and for rails, it has
ruby plugins, but it can be used to deploy any other application (static, js, php, etc)

To use a plugin you only need to require it in your `deploy.rb`. Most of the plugins come with a set of their
own variables which are usable, chengable and overwritable.

Example:

``` ruby
require 'mina/rails'

set :rails_env, 'staging'
```

You can also override a variable from command line like:

``` sh
$ mina deploy rails_env=development
```

## Default

``` ruby
require 'mina/default'
```

### Variables
``` ruby
  :repository             #=> nil
  :domain                 #=> nil
  :port                   #=> 22
  :deploy_to              #=> nil
  :execution_mode         #=> :pretty ## Can be [:exec, :pretty, :pritner, :system]
```

### Execution mode
See [Execution mode](how_mina_works.md#execution-modes-runners)

### Tasks
``` ruby
  local_environment       #=> Task to be run before all local tasks
  remote_environment      #=> Task to be run before all remote tasks
  ssh_keyscan_domain      #=> Adds repository host to the known hosts
  ssh_keyscan_repo        #=> Adds domain to the known hosts
  run                     #=> Runs a command on the server; Example: `$ mina 'run[rake db:migrate]'`
  ssh                     #=> Open an ssh session to the server and cd to deploy_to folder
```

## Deploy
``` ruby
require 'mina/deploy'
```

loads:
- `mina/default`

### Variables

``` ruby
  :releases_path          #=> "#{fetch(:deploy_to)}/releases"
  :shared_path            #=> "#{fetch(:deploy_to)}/shared"
  :current_path           #=> "#{fetch(:deploy_to)}/current"
  :lock_file              #=> 'deploy.lock'
  :deploy_script          #=> 'data/deploy.sh.erb'
  :keep_releases          #=> 5
  :version_scheme         #=> :sequence ## Can be [:sequence, :datetime]
  :shared_dirs            #=> []
  :shared_fiels           #=> []
```

### Tasks
``` ruby
  # deploy:* tasks are not meant to be run outside `deploy do` block
  deploy:force_unlock      #=> Removes .force_unlock file
  deploy:link_shared_paths #=> Link paths set in `:shared_dirs` and `:shared_files`
  deploy:cleanup           #=> Cleans up old releases

  rollback                 #=> Rollbacks the latest release; does not rollback database
  setup                    #=> Sets up the site
```

#### Version scheme

`:version_scheme` variable sets the naming for your release folders.

``` sh
# :sequence
.
├── releases
│   ├── 87
│   ├── 88
│   ├── 89
│   ├── 90
│   ├── 91
│   └── 92

# :datetime
.
├── releases
│   ├── 20170701123242
│   ├── 20170704131253
│   ├── 20170708032142
│   ├── 20170710082353
│   └── 20170720012031
```

## Git
``` ruby
require 'mina/git'
```
loads:
- `mina/default`

### Variables
``` ruby
  :branch                 #=> 'master'
  :remove_git_dir         #=> true
  :remote                 #=> 'origin'
  :git_not_pushed_message #=> "Your branch #{fetch(:branch)} needs to be pushed to #{fetch(:remote)} before deploying"
```

### Tasks
``` ruby
  # git:clone is not meant to be run outside `deploy do` block
  git:clone               #=> Clones the Gir repository to the current path
  git:revision            #=> Prints out current revision
  git:ensure_pushed       #=> Ensures local repository is pushed to remote
```

## Bunlder
``` ruby
require 'mina/bunlder'
```
loads:
- `mina/default`

### Variables
``` ruby
  :bundle_bin             #=> 'bundle'
  :bundle_path            #=> 'vendor/bundle'
  :bundle_withouts        #=> 'development test'
  :bundle_options         #=> "--without #{fetch(:bundle_withouts)} --path "#{fetch(:bundle_path)}" --deployment"
  :shared_dirs            #=> fetch(:shared_dirs, []).push(fetch(:bundle_path)) ## Add `bundle_path` to `shared_dirs`
```

### Tasks

``` ruby
  bundle:install          #=> Install gem dependencies using Bundler
  bundle:clean            #=> Cleans up unused gems in your bundler directory
```

## Rails
``` ruby
require 'mina/rails'
```
loads:
- `mina/deploy`
- `mina/bundler`

### Variables
``` ruby
  :rails_env              #=> 'production'
  :bundle_prefix          #=> %{RAILS_ENV="#{fetch(:rails_env)}" #{fetch(:bundle_bin)} exec}
  :rake                   #=> "#{fetch(:bundle_prefix)} rake"
  :rails                  #=> "#{fetch(:bundle_prefix)} rails"
  :compiled_asset_path    #=> 'public/assets'
  :asset_dirs             #=> ['vendor/assets/', 'app/assets/']
  :migration_dirs         #=> ['db/migrate']
  :force_migrate          #=> false
  :force_asset_precompile #=> false
```

### Tasks
``` ruby
  console                 #=> Starts and interactive console
  log                     #=> Tail log from server
  rails[command]          #=> Runs rails command; example `$ mina 'rails[console]'`
  rake[command]           #=> Runs rake command; example `$ mina 'rake[db:migrate]'`

  # rails:* tasks are not meant to be run outside of `deploy do` block. Please use the tasks above.
  rails:db_migrate        #=> Checks for changes in `:migration_dirs` and runs `db:migrate` if needed. Can be forced with `:force_migrate` variable
  rails:assets_precompile #=> Checks for changes in `:asset_dirs` and runs `assets:precomile` if needed. Can be fored with `:force_asset_precompile` variable
  rails:db_create         #=> Runs `db:create`
  rails:db_rollback       #=> Runs `db:rollback`
  rails:assets_clean      #=> Runs `assets:clean`
  rails:db_schema_load    #=> Runs `db:schema:load`
```
