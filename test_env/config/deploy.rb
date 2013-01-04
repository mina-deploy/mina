# NOTE:
# Yes, you can deploy this project. It will deploy into the ./deploy/
# directory.  The commands have been stubbed, so it's harmless. No rails or
# bundler magic will happen.

# ASSUMPTIONS:
# - You have git installed. (of course you do)
# - You have SSH enabled. In OS X, this is "Remote Login" under the Sharing pref pane.
# - You have your own SSH key added to your own user so you can SSH to your own machine.

# In fact, let's make that folder right now.
require 'fileutils'
FileUtils.mkdir_p "#{Dir.pwd}/deploy"
FileUtils.mkdir_p "#{Dir.pwd}/deploy/config"
File.open("#{Dir.pwd}/deploy/config/database.yml", 'w') { |f| f.write "Hello" }

# -- Stubs end, deploy script begins! --------------

require 'mina/rails'
require 'mina/bundler'
require 'mina/git'

set :domain, 'localhost'
set :deploy_to, "#{Dir.pwd}/deploy"
set :repository, "#{Mina.root_path}"
set :shared_paths, ['config/database.yml']

task :environment do
  queue %[echo "-----> Loading env"]
end

desc "Deploys."
task :deploy do
  queue "bundle() { true; }" # Stub the bundle command.

  deploy do
    queue %[ruby -e "\\$stderr.write \\\"This is stdout output\n\\\""]
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'

    to :launch do
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

task :rofl do
  set :term_mode, :pretty
  queue %[echo "Password:"; read x; echo out: $x;]
end
