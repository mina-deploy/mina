# # NOTE:
# # Yes, you can deploy this project. It will deploy into the ./deploy/
# # directory.  The commands have been stubbed, so it's harmless. No rails or
# # bundler magic will happen.
#
# # ASSUMPTIONS:
# # - You have git installed. (of course you do)
# # - You have SSH enabled. In OS X, this is "Remote Login" under the Sharing pref pane.
# # - You have your own SSH key added to your own user so you can SSH to your own machine.
#
# # In fact, let's make that folder right now.
# require 'fileutils'
# FileUtils.mkdir_p "#{Dir.pwd}/deploy"
# FileUtils.mkdir_p "#{Dir.pwd}/deploy/config"
# File.open("#{Dir.pwd}/deploy/config/database.yml", 'w') { |f| f.write "Hello" }
#
# # -- Stubs end, deploy script begins! --------------
#

require 'mina/git'
require 'mina/rails'
require 'mina/rvm'
require 'mina/rbenv'
require 'mina/chruby'
require 'pry'
#

set :domain, 'localhost'
set :deploy_to, "#{Dir.pwd}/deploy"
set :repository, "#{Mina.root_path}"
set :shared_paths, ['config/database.yml', 'log']
set :keep_releases, 2

task :environment do
  invoke :'rbenv:load'
end
#
# desc "Deploys."
task :deploy do
  run :local do
    puts 'buja'
  end

  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'deploy:cleanup'

    on :launch do
      comment %{in launch}
    end
  end
end

desc 'Task description'
task :test do
  run :remote do
    comment %{PWD}
    in_path('/Users') do
      command %{ls -al}
    end
    on :after do
      command %{pwd}
    end
  end

  run :local do
    command %{ls -al}
  end
end
