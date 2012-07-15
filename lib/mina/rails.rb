require 'mina/bundler'

settings.rails_env ||= 'production'
# TODO: This should be lambda
settings.bundle_prefix ||= lambda { %{RAILS_ENV="#{rails_env}" #{bundle_bin} exec} }
settings.rake ||= lambda { %{#{bundle_prefix} rake} }
settings.rails ||= lambda { %{#{bundle_prefix} rails} }
settings.asset_paths ||= ['vendor/assets/', 'app/assets/']
settings.rake_assets_precompile ||= lambda { "#{rake} assets:precompile" }

desc "Makes Rails 3.2 deploys faster."
task :'rails:optimize_for_3.2' do
  # This is 100% faster in Rails 3.2 because it skips re-invoking the
  # Rake+Rails environment twice, and reuses the compilation cache for
  # generating digest and non-digest assets. See:
  # https://github.com/rails/rails/blob/3-2-stable/actionpack/lib/sprockets/assets.rake
  settings.rake_assets_precompile = lambda {
    "#{rake} assets:precompile:primary assets:precompile:nondigest RAILS_ENV=production RAILS_GROUPS=assets"
  }

  # A safer, but slower (and still faster than default) version would be the
  # one below. This will respect your config.assets.digest setting.
  # settings.rake_assets_precompile = lambda {
  #   "#{rake} assets:precompile:all RAILS_ENV=production RAILS_GROUPS=assets"
  # }
end

# Macro used later by :rails, :rake, etc
make_run_task = lambda { |name, sample_args|
  task name, :arguments do |t, args|
    arguments = args[:arguments]
    command = send name
    unless command
      puts %{You need to provide arguments. Try: mina "#{name}[#{sample_args}]"}
      exit 1
    end
    queue echo_cmd %[cd "#{deploy_to!}/#{current_path!}" && #{command} #{arguments}]
  end
}

def check_for_changes_script(options={})
  diffs = options[:at].map { |path|
    %[diff -r "#{deploy_to}/#{current_path}/#{path}" "./#{path}" 2>/dev/null]
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

desc "Execute a Rails command in the current deploy."
make_run_task[:rails, 'console']

desc "Execute a Rake command in the current deploy."
make_run_task[:rake, 'db:migrate']

desc "Starts an interactive console."
task :console do
  queue echo_cmd %[cd "#{deploy_to!}/#{current_path!}" && #{rails} console]
end

namespace :rails do
  desc "Migrates the Rails database (skips if nothing has changed since the last release)."
  task :db_migrate do
    if ENV['force_migrate']
      invoke :'rails:db_migrate:force'
    else
      message = verbose_mode? ?
        '$((count)) changes found, migrating database' :
        'Migrating database'

      queue check_for_changes_script \
        :check => 'db/schema.rb',
        :at => ['db/schema.rb'],
        :skip => %[
          echo "-----> DB schema unchanged; skipping DB migration"
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

  desc "Migrates the Rails database."
  task :'db_migrate:force' do
    queue %{
      echo "-----> Migrating database"
      #{echo_cmd %[#{rake} db:migrate]}
    }
  end

  desc "Precompiles assets."
  task :'assets_precompile:force' do
    queue %{
      echo "-----> Precompiling asset files"
      #{echo_cmd %[#{rake_assets_precompile}]}
    }
  end

  desc "Precompiles assets (skips if nothing has changed since the last release)."
  task :'assets_precompile' do
    if ENV['force_assets']
      invoke :'rails:assets_precompile:force'
    else
      message = verbose_mode? ?
        '$((count)) changes found, precompiling asset files' :
        'Precompiling asset files'

      queue check_for_changes_script \
        :check => 'public/assets/',
        :at => [*asset_paths],
        :skip => %[
          echo "-----> Skipping asset precompilation"
          #{echo_cmd %[cp -R "#{deploy_to}/#{current_path}/public/assets" "./public/assets"]}
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
