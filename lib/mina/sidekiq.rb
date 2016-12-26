# # Modules: Sidekiq
# Adds settings and tasks for managing Sidekiq workers.
#
# ## Usage example
#     require 'mina/sidekiq'
#     ...
#
#     task :deploy => :enviroment do
#       deploy do
#         invoke :'sidekiq:quiet'
#         invoke :'git:clone'
#         ...
#
#         to :launch do
#           ...
#           invoke :'sidekiq:restart'
#         end
#       end
#     end

require 'mina/bundler'
require 'mina/rails'

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### sidekiq
# Sets the path to sidekiq.
set_default :sidekiq, lambda { "#{bundle_bin} exec sidekiq" }

# ### sidekiqctl
# Sets the path to sidekiqctl.
set_default :sidekiqctl, lambda { "#{bundle_prefix} sidekiqctl" }

# ### sidekiq_timeout
# Sets a upper limit of time a worker is allowed to finish, before it is killed.
set_default :sidekiq_timeout, 10

# ### sidekiq_config
# Sets the path to the configuration file of sidekiq
set_default :sidekiq_config, "./config/sidekiq.yml"

# ### sidekiq_log
# Sets the path to the log file of sidekiq
#
# To disable logging set it to "/dev/null"
set_default :sidekiq_log, "./log/sidekiq.log"

# ### sidekiq_pid
# Sets the path to the pid file of a sidekiq worker
set_default :sidekiq_pid, lambda { "#{deploy_to}/#{shared_path}/pids/sidekiq.pid" }

# ## Control Tasks
namespace :sidekiq do
  # ### sidekiq:quiet
  desc "Quiet sidekiq (stop accepting new work)"
  task :quiet do
    queue %{ if [ -f #{sidekiq_pid} ]; then
      echo "-----> Quiet sidekiq (stop accepting new work)"
      #{echo_cmd %{(cd #{deploy_to}/#{current_path} && #{sidekiqctl} quiet #{sidekiq_pid})} }
      fi }
  end

  # ### sidekiq:stop
  desc "Stop sidekiq"
  task :stop do
    queue %[ if [ -f #{sidekiq_pid} ]; then
      echo "-----> Stop sidekiq"
      #{echo_cmd %[(cd #{deploy_to}/#{current_path} && #{sidekiqctl} stop #{sidekiq_pid} #{sidekiq_timeout})]}
      fi ]
  end

  # ### sidekiq:start
  desc "Start sidekiq"
  task :start do
    queue %{
      echo "-----> Start sidekiq"
      #{echo_cmd %[(cd #{deploy_to}/#{current_path}; nohup #{sidekiq} -e #{rails_env} -C #{sidekiq_config} -P #{sidekiq_pid} >> #{sidekiq_log} 2>&1 </dev/null &) ] }
      }
  end

  # ### sidekiq:restart
  desc "Restart sidekiq"
  task :restart do
    invoke :'sidekiq:stop'
    invoke :'sidekiq:start'
  end
end

