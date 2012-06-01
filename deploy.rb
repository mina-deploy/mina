require 'van_helsing/bundler'
require 'van_helsing/rails'
require 'van_helsing/git'

set :host, 'streakdeals.com.ph'
set :deploy_to, '/var/www/streakdeals.com.ph'
set :repository, 'git://github.com/rstacruz/sinatra-assetpack'

desc "Deploys."
task :deploy do
  deploy! do
    invoke :'git:clone'
    invoke :'bundle:install'
    invoke :'rails:assets_precompile'
    invoke :'rails:db_migrate'

    to :restart do
      invoke :'nginx:restart'
    end
  end
end
