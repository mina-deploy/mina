require 'van_helsing/bundler'
require 'van_helsing/rails'
require 'van_helsing/git'

set :host, 'localhost'
set :deploy_to, "#{Dir.pwd}/deploy"
set :repository, 'git://github.com/nadarei/van_helsing.git'

# Stub
require 'fileutils'
FileUtils.mkdir_p deploy_to

desc "Deploys."
task :deploy do
  invoke :'growl:notify' # pre deploy

  deploy do
    invoke :'git:clone'
    # invoke :'bundle:install'
    # invoke :'rails:assets_precompile'
    invoke :'rails:db_migrate'
    # invoke :'cdn:propagate'

    to :restart do
      invoke :'passenger:restart'
    end

    to :clean do
      # invoke :'cdn:cleanup'
    end
  end
end

desc "Restarts the passenger server."
task :restart do
  invoke :'passenger:restart'
end

task(:'growl:notify') {}
task(:'cdn:propagate') {}
task(:'cdn:activate') {}
task(:'cdn:cleanup') {}

# task :force_unlock do
#   queue "rm -f #{deploy_to}/deploy.lock"
#   run!
# end

namespace :passenger do
  task :restart do
    queue %{
      echo "-----> Restarting passenger"
      touch tmp/restart.txt
    }
  end
end
