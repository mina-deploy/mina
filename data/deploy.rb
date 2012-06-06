require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

# Basic settings:
# host       - The hostname to SSH to
# deploy_to  - Path to deploy into
# repository - Git repo to clone from (needed by mina/git)
# user       - Username in the  server to SSH to (optional)

set :host, 'foobar.com'
set :deploy_to, '/var/www/foobar.com'
set :repository, 'git://...'
# set :user, 'foobar.com'

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:checkout'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      queue 'touch tmp/restart.txt'
    end
  end
end
