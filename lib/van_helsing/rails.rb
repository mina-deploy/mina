settings.rails_env ||= 'production'
# TODO: This should be lambda
settings.rake ||= lambda { %{RAILS_ENV="#{rails_env}" bundle exec rake} }

namespace :rails do
  desc "Migrates the Rails database."
  task :db_migrate do
    queue %{
      echo "-----> Migrating database"
      #{rake} db:migrate
    }
  end

  desc "Precompiles assets."
  task :'assets_precompile:force' do
    queue %{
      echo "-----> Precompiling asset files"
      #{rake} assets:precompile
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
          cp -R "#{current_path}/public/assets" "./public/assets" && exit
        fi
      fi

      echo "-----> Precompiling asset files"
      #{rake} assets:precompile
    }
  end

end
