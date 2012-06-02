# Edit this file.

require 'van_helsing/git'
require 'van_helsing/bundler'
require 'van_helsing/rails'

task :deploy do
  deploy do
    invoke :'git:checkout'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :restart do
      queue 'touch tmp/restart.txt'
    end
  end
end
