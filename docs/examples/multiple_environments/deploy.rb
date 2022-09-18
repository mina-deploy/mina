# frozen_string_literal: true

require 'mina/deploy'
require 'mina/git'

set :repository, 'git@github.com:org/repo.git'

task :staging do
  set :domain, 'staging.example.com'
  set :deploy_to, 'home/deploy/www/app-staging/'
  set :user, 'staging_ssh_user'
  set :branch, 'staging'
end

task :production do
  set :domain, 'production.example.com'
  set :deploy_to, 'home/deploy/www/app-production/'
  set :user, 'production_ssh_user'
  set :branch, 'master'
end

task :deploy do
  deploy do
    invoke 'git:clone'
  end
end
