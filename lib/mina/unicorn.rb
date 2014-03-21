# # Modules: Unicorn
# Adds settings and tasks for managing projects with [unicorn].
#
# NOTE: Requires sudo privileges
#
# [unicorn]: http://unicorn.bogomips.org/
#
#    require 'mina/unicorn'
#
# ## Common usage
#
#    set :application, "app-name"
#
#    task :deploy => :environment do
#      deploy do
#        # ...
#      end
#
#      to :launch do
#        invoke 'unicorn:restart'
#      end
#    end
#

namespace :unicorn do
  desc "Start unicorn service"
  task :start do
    queue %{
      echo "-----> Starting unicorn service"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!}; RAILS_ENV=production bundle exec unicorn_rails -c config/unicorn.rb -D]}
    }
  end

  desc "Stop unicorn service"
  task :stop do
    queue %{
      echo "-----> Stoping unicorn service"
      #{echo_cmd %[kill -s QUIT `cat #{deploy_to!}/#{current_path!}/tmp/pids/unicorn.pid`]}
    }
  end

  desc "Zero-downtime restart of unicorn service"
  task :restart do
    queue %{
      echo "-----> Zero-downtime restart of unicorn service"
      #{echo_cmd %[kill -s USR2 `cat #{deploy_to!}/#{current_path!}/tmp/pids/unicorn.pid`]}
    }
  end
end
