require 'van_helsing/bundler'
require 'van_helsing/rails'
require 'van_helsing/git'

set :host, 'foobar.com'               # The hostname to SSH to
set :deploy_to, '/var/www/foobar.com' # Path to deploy from
set :repository, 'git://...'          # Git repo to clone from (needed by van_helsing/git)
# set :user, 'foobar.com'    # Username in that server (optional)

task :deploy do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:checkout'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :restart do
      queue 'touch tmp/restart.txt'
    end
  end
end
