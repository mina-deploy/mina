settings.rails_env ||= 'production'

namespace :rails do
  task :db_migrate do
    queue %{
      echo "-----> Migrating database"
      RAILS_ENV="#{rails_env}" bundle exec rake db:migrate
    }
  end

  task :assets_precompile do
    queue %{
      echo "-----> Precompiling asset files"
      RAILS_ENV="#{rails_env}" bundle exec rake assets:precompile
    }
  end
end
