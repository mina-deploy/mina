settings.rails_env ||= 'production'
# TODO: This should be lambda
settings.bundle_prefix ||= lambda { %{RAILS_ENV="#{rails_env}" bundle exec} }
settings.rake ||= lambda { %{#{bundle_prefix} rake} }
settings.rails ||= lambda { %{#{bundle_prefix} rails} }

# Macro used later by :rails, :rake, etc
make_run_task = lambda { |name, sample_args|
  task name, :arguments do |t, args|
    command = args[:arguments]
    unless command
      puts %{You need to provide arguments. Try: mina "#{name}[#{sample_args}]"}
      exit 1
    end
    queue %[cd "#{deploy_to!}/#{current_path!}" && #{rails} #{command}]
  end
}

desc "Execute a Rails command in the current deploy."
make_run_task[:rails, 'console']

desc "Execute a Rake command in the current deploy."
make_run_task[:rake, 'db:migrate']

namespace :rails do
  desc "Migrates the Rails database."
  task :db_migrate do
    queue %{
      echo "-----> Migrating database"
      #{echo_cmd %[#{rake} db:migrate]}
    }
  end

  desc "Precompiles assets."
  task :'assets_precompile:force' do
    queue %{
      echo "-----> Precompiling asset files"
      #{echo_cmd %[#{rake} assets:precompile]}
    }
  end

  desc "Precompiles assets (skips if nothing has changed since the last release)."
  task :'assets_precompile' do
    if ENV['force_assets']
      invoke :'rails:assets_precompile:force'
      return
    end

    queue %{
      # Check if the last deploy has assets built, and if it can be re-used.
      if [ -d "#{current_path}/public/assets" ]; then
        count=`(
          diff -r "#{current_path}/vendor/assets/" "./vendor/assets/" 2>/dev/null;
          diff -r "#{current_path}/app/assets/" "./app/assets/" 2>/dev/null
        ) | wc -l`

        if [ "$((count))" = "0" ]; then
          echo "-----> Skipping asset precompilation"
          #{echo_cmd %[cp -R "#{current_path}/public/assets" "./public/assets"]} &&
          exit
        fi
      fi

      echo "-----> Precompiling asset files"
      #{echo_cmd %[#{rake} assets:precompile]}
    }
  end

end
