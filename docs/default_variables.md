Default Variables
-----------------

The variables in the list below are usable, chengable and overwritable if you include the plugin in your `deploy.rb` script.
Example:

```
require 'mina/rails'

set :rails_env, 'staging'
```

You can also override a variable from command line like:

```
mina deploy rails_env=development
```

### Default plugin
```
  :repository             #=> nil
  :domain                 #=> nil
  :port                   #=> 22
  :deploy_to              #=> nil
```

### Deploy plugin
```
  :releases_path          #=> "#{fetch(:deploy_to)}/releases"
  :shared_path            #=> "#{fetch(:deploy_to)}/shared"
  :current_path           #=> "#{fetch(:deploy_to)}/current"
  :lock_file              #=> 'deploy.lock'
  :deploy_script          #=> 'data/deploy.sh.erb'
  :keep_releases          #=> 5
  :version_scheme         #=> :sequence ## Can be [:sequence, :datetime]
  :execution_mode         #=> :pretty   ## Can be [:exec, :pretty, :pritner, :system]
  :shared_dirs            #=> []
  :shared_fiels           #=> []
```

### Git Plugin
```
  :branch                 #=> 'master'
  :remove_git_dir         #=> true
  :remote                 #=> 'origin'
  :git_not_pushed_message #=> "Your branch #{fetch(:branch)} needs to be pushed to #{fetch(:remote)} before deploying"
```

### Bunlder plugin
```
  :bundle_bin             #=> 'bundle'
  :bundle_path            #=> 'vendor/bundle'
  :bundle_withouts        #=> 'development test'
  :bundle_options         #=> "--without #{fetch(:bundle_withouts)} --path "#{fetch(:bundle_path)}" --deployment"
  :shared_dirs            #=> fetch(:shared_dirs, []).push(fetch(:bundle_path)) ## Add `bundle_path` to `shared_dirs`
```

### Rails plugin
```
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
