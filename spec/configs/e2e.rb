# frozen_string_literal: true

require 'mina/git'

set :simulate, false
set :user, 'mina-ssh'
set :domain, '0.0.0.0'
set :port, 2222
set :deploy_to, '/app'

set :repository, 'https://github.com/mina-deploy/mina.git'
set :branch, 'master'

set :identity_file, './spec/e2e/ssh'

set :ssh_options, '-o StrictHostKeyChecking=no'

desc 'Deploys to the server'
task :e2e_deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'deploy:cleanup'
  end
end
