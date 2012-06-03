# NOTE:
# Yes, you can deploy this project. It will deploy into the ./deploy/
# directory.  The commands have been stubbed, so it's harmless. No rails or
# bundler magic will happen.

# In fact, let's make that folder right now.
require 'fileutils'
FileUtils.mkdir_p "#{Dir.pwd}/deploy"

# -----------------

require 'van_helsing/rails'
require 'van_helsing/git'

set :host, 'localhost'
set :deploy_to, "#{Dir.pwd}/deploy"
set :repository, 'git://github.com/nadarei/van_helsing.git'

desc "Deploys."
task :deploy do
  invoke :'growl:notify' # pre deploy

  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'cdn:propagate'

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
      mkdir -p tmp
      touch tmp/restart.txt
    }
  end
end

# STUBS!
# These are here so this deploy script can actually work and it won't do fancy
# bundle commands or whatever.
task(:'growl:notify') {}
task(:'cdn:propagate') {}
set :rake, "echo $ bundle exec rake"
desc "Install gem dependencies using Bundler"
task(:'bundle:install') {
  queue %{
    echo "-----> Installing gem dependencies using Bundler"
    echo $ bundle install #{bundle_options}
  }
}

