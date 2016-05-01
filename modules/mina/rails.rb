# # Modules: Rails
# Adds settings and tasks for managing Rails projects.
#
#     require 'mina/rails'

require 'mina/bundler'

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### rails_env
# Sets the Rails environment for `rake` and `rails` commands.
#
# Note that changing this will NOT change the environment that your application
# is run in.

set_default :rails_env, 'production'

# ### bundle_prefix
# Prefix for Bundler commands. Often to something like `RAILS_ENV=production
# bundle exec`.
#
#     queue! "#{bundle_prefix} annotate -r"

set_default :bundle_prefix, lambda { %{RAILS_ENV="#{rails_env}" #{bundle_bin} exec} }

# ### rake
# The prefix for `rake` commands. Use like so:
#
#     queue! "#{rake} db:migrate"

set_default :rake, lambda { %{#{bundle_prefix} rake} }

# ### rails
# The prefix for `rails` commands. Use like so:
#
#     queue! "#{rails} console"

set_default :rails, lambda { %{#{bundle_prefix} rails} }

# ### asset_paths
# The paths to be checked.
#
# Whenever assets are compiled, the asset files are checked if they have
# changed from the previous release.
#
# If they're unchanged, compiled assets will simply be copied over to the new
# release.
#
# Override this if you have custom asset paths declared in your Rails's
# `config.assets.paths` setting.

set_default :asset_paths, ['vendor/assets/', 'app/assets/']

# ### compiled_asset_path
# The path to be copied to the new release.
#
# The path your assets are compiled to. If your `assets_path` assets have changed,
# this is the folder that gets copied accross from the current release to the new release.
#
# Override this if you have custom public asset paths.

set_default :compiled_asset_path, 'public/assets'

# ### rake_assets_precompile
# The command to invoke when precompiling assets.
# Override me if you like.

settings.rake_assets_precompile ||= lambda { "#{rake} assets:precompile RAILS_GROUPS=assets" }

# ----

# Macro used later by :rails, :rake, etc
make_run_task = lambda { |name, sample_args|
  task name, [:arguments] => :environment do |t, args|
    arguments = args[:arguments]
    command = send name
    unless arguments
      puts %{You need to provide arguments. Try: mina "#{name}[#{sample_args}]"}
      exit 1
    end
    queue echo_cmd %[cd "#{deploy_to!}/#{current_path!}" && #{command} #{arguments}]
  end
}

def check_for_changes_script(options={})
  diffs = options[:at].map { |path|
    %[diff -rN "#{deploy_to}/#{current_path}/#{path}" "./#{path}" 2>/dev/null]
  }.join("\n")

  unindent %[
    if [ -e "#{deploy_to}/#{current_path}/#{options[:check]}" ]; then
      count=`(
        #{reindent 4, diffs}
      ) | wc -l`

      if [ "$((count))" = "0" ]; then
        #{reindent 4, options[:skip]} &&
        exit
      else
        #{reindent 4, options[:changed]}
      fi
    else
      #{reindent 2, options[:default]}
    fi
  ]
end

# ## Command-line tasks
# These tasks can be invoked in the command line.

# ### rails[]
# Invokes a rails command.
#
#     $ mina "rails[console]"

desc "Execute a Rails command in the current deploy."
make_run_task[:rails, 'console']

# ### rake[]
# Invokes a rake command.
#
#     $ mina "rake[db:migrate]"

desc "Execute a Rake command in the current deploy."
make_run_task[:rake, 'db:migrate']

# ### console
# Opens the Ruby console for the currently-deployed version.
#
#     $ mina console

desc "Starts an interactive console."
task :console => :environment do
  queue echo_cmd %[cd "#{deploy_to!}/#{current_path!}" && #{rails} console && exit]
end

# ### log
# Tail log from server
#
#     $ mina log

desc "Tail log from server"
task :log => :environment do
  queue %[tail -f #{deploy_to}/#{current_path}/log/#{rails_env}.log]
end

# ## Deploy tasks
# These tasks are meant to be invoked inside deploy scripts, not invoked on
# their own.

namespace :rails do
  # ### rails:db_migrate
  desc "Migrates the Rails database (skips if nothing has changed since the last release)."
  task :db_migrate do
    if ENV['force_migrate']
      invoke :'rails:db_migrate:force'
    else
      message = verbose_mode? ?
        '$((count)) changes found, migrating database' :
        'Migrating database'

      queue check_for_changes_script \
        :check => 'db/migrate/',
        :at => ['db/migrate/'],
        :skip => %[
          echo "-----> DB migrations unchanged; skipping DB migration"
        ],
        :changed => %[
          echo "-----> #{message}"
          #{echo_cmd %[#{rake} db:migrate]}
        ],
        :default => %[
          echo "-----> Migrating database"
          #{echo_cmd %[#{rake} db:migrate]}
        ]
    end
  end

  # ### rails:db_migrate:force
  desc "Migrates the Rails database."
  task :'db_migrate:force' do
    queue %{
      echo "-----> Migrating database"
      #{echo_cmd %[#{rake} db:migrate]}
    }
  end

  # ### rails:db_create
  desc "Creates the Rails database."
  task :'db_create' do
    queue %{
      echo "-----> Creating database"
      #{echo_cmd %[#{rake} db:create]}
    }
  end

  # ### rails:db_rollback
  desc "Rollbacks the Rails database."
  task :'db_rollback' do
    queue %{
      echo "-----> Rollbacking database"
      #{echo_cmd %[#{rake} db:rollback]}
    }
  end

  # ### rails:assets_precompile:force
  desc "Precompiles assets."
  task :'assets_precompile:force' do
    queue %{
      echo "-----> Precompiling asset files"
      #{echo_cmd %[#{rake_assets_precompile}]}
    }
  end

  # ### rails:assets_precompile
  desc "Precompiles assets (skips if nothing has changed since the last release)."
  task :'assets_precompile' do
    if ENV['force_assets']
      invoke :'rails:assets_precompile:force'
    else
      message = verbose_mode? ?
        '$((count)) changes found, precompiling asset files' :
        'Precompiling asset files'

      queue check_for_changes_script \
        :check => compiled_asset_path,
        :at => [*asset_paths],
        :skip => %[
          echo "-----> Skipping asset precompilation"
          #{echo_cmd %[mkdir -p "#{deploy_to}/$build_path/#{compiled_asset_path}"]}
          #{echo_cmd %[cp -R "#{deploy_to}/#{current_path}/#{compiled_asset_path}/." "#{deploy_to}/$build_path/#{compiled_asset_path}"]}
        ],
        :changed => %[
          echo "-----> #{message}"
          #{echo_cmd %[#{rake_assets_precompile}]}
        ],
        :default => %[
          echo "-----> Precompiling asset files"
          #{echo_cmd %[#{rake_assets_precompile}]}
        ]
    end
  end

end
