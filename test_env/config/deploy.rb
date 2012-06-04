# NOTE:
# Yes, you can deploy this project. It will deploy into the ./deploy/
# directory.  The commands have been stubbed, so it's harmless. No rails or
# bundler magic will happen.

# In fact, let's make that folder right now.
require 'fileutils'
ROOT = File.expand_path('../../../', __FILE__)
FileUtils.mkdir_p "#{ROOT}/test_env/deploy"

# -- Stubs end, deploy script begins! --------------

require 'van_helsing/rails'
require 'van_helsing/bundler'
require 'van_helsing/git'

set :host, 'localhost'
set :deploy_to, "#{Dir.pwd}/deploy"
set :repository, "#{ROOT}"

desc "Deploys."
task :deploy do
  queue "bundle() { true; }" # Stub the bundle command.

  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'

    to :restart do
      invoke :'passenger:restart'
    end
  end
end

desc "Restarts the passenger server."
task :restart do
  invoke :'passenger:restart'
end

namespace :passenger do
  task :restart do
    queue %{
      echo "-----> Restarting passenger"
      #{echo_cmd %[mkdir -p tmp]}
      #{echo_cmd %[touch tmp/restart.txt]}
    }
  end
end
