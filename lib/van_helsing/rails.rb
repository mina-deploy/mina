settings.rails_env ||= 'production'
# TODO: This should be lambda
settings.rake ||= %{RAILS_ENV="#{rails_env}" bundle exec rake}

namespace :rails do
  desc "Migrates the Rails database."
  task :db_migrate do
    queue %{
      echo "-----> Migrating database"
      #{rake} db:migrate
    }
  end

  desc "Precompiles assets."
  task :assets_precompile do
    queue %{
      echo "-----> Precompiling asset files"
      #{rake} assets:precompile
    }
  end

  desc "Precompiles assets (skips if nothing has changed since the last release)."
  task :'assets_precompile:fast' do
    queue %{
      if [ -d "#{current_path}/public/assets" ]; then

        count=`(
          diff -r "#{current_path}/vendor/assets/" "#{release_path}/vendor/assets/" 2>/dev/null;
          diff -r "#{current_path}/app/assets/" "#{release_path}/app/assets/" 2>/dev/null
        ) | wc -l`

        if [ "$((count))" = "0" ]; then
          echo "-----> Skipping asset precompilation"
          cp -R "#{current_path}/public/assets" "#{release_path}/public/assets"
        else
          echo "-----> Precompiling asset files"
          #{rake} assets:precompile
        fi
      fi
    }
  end

end
