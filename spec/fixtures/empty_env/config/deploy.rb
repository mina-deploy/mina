require 'fileutils'
FileUtils.mkdir_p "#{Dir.pwd}/deploy"

require 'mina/git'

set :domain, 'localhost'
set :deploy_to, "#{Dir.pwd}/deploy"
set :repository, "#{Dir.pwd}"

desc "Deploys."
task :deploy do
  deploy do
    invoke :'git:clone'
  end
end
