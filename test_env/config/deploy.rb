require 'van_helsing/recipes/bundler'
require 'van_helsing/recipes/rails'
require 'van_helsing/recipes/git'

set :hostname, 'streakdeals.com.ph'
set :deploy_to, '/var/www/streakdeals.com.ph'
set :repository, 'git://github.com/rstacruz/sinatra-assetpack'

task :deploy do
  invoke :'growl:notify' # pre deploy

  deploy! do
    # prepare do
      invoke :'git:clone'
      invoke :'bundle:install'
      invoke :'rails:assets_precompile'
      invoke :'rails:db_migrate'
      invoke :'cdn:propagate'
    # end

    # restart do
      invoke :'nginx:restart'
      invoke :'cdn:activate'
    # end

    # failure do
    #   invoke :'cdn:cleanup'
    # end
  end

  invoke :'git:tag_release' # post deploy
end

task :restart do
  invoke :'nginx:restart'
  run!
end

task(:'scm:checkout') { }
task(:'growl:notify') {}
task(:'cdn:propagate') { }
task(:'cdn:activate') { }
task(:'cdn:cleanup') { }
task(:'git:tag_release') { }

# task :force_unlock do
#   queue "rm -f #{deploy_to}/deploy.lock"
#   run!
# end

namespace :nginx do
  task :restart do
    queue 'echo "-----> Restarting nginx"'
    queue 'sudo /opt/sbin/nginx -s reload'
  end
end
