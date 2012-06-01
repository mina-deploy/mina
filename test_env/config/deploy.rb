require 'van_helsing/bundler'
require 'van_helsing/rails'
require 'van_helsing/git'

set :host, 'localhost'
set :deploy_to, "#{Dir.pwd}/releases"
set :repository, 'git://github.com/nadarei/van_helsing.git'

desc "Deploys."
task :deploy do
  invoke :'growl:notify' # pre deploy

  deploy! do
    invoke :'git:clone'
    invoke :'bundle:install'
    invoke :'rails:assets_precompile'
    invoke :'rails:db_migrate'
    invoke :'cdn:propagate'

    to :restart do
      invoke :'nginx:restart'
      invoke :'cdn:activate'
    end

    to :clean do
      invoke :'cdn:cleanup'
    end
  end

  invoke :'git:tag_release' # post deploy
end

desc "Restarts the nginx server."
task :restart do
  invoke :'nginx:restart'
  run!
end

task(:'growl:notify') {}
task(:'cdn:propagate') {}
task(:'cdn:activate') {}
task(:'cdn:cleanup') {}

# task :force_unlock do
#   queue "rm -f #{deploy_to}/deploy.lock"
#   run!
# end

namespace :nginx do
  task :restart do
    queue %{
      echo "-----> Restarting nginx"
      sudo /opt/sbin/nginx -s reload
    }
  end
end
