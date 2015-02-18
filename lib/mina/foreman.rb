# # Modules: Foreman
# Adds settings and tasks for managing projects with [foreman].
#
# NOTE: Requires sudo privileges
#
# [foreman]: http://rubygems.org/ddolar/foreman
#
#    require 'mina/foreman'
#
# ## Common usage
#
#    set :application, "app-name"
#
#    task :deploy => :environment do
#      deploy do
#        # ...
#        invoke 'foreman:export'
#        # ...
#      end
#
#      to :launch do
#        invoke 'foreman:restart'
#      end
#    end
#

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### foreman_app
# Sets the service name that foreman will export to upstart. Uses *application*
# variable as a default. It should be set, otherwise export command will fail.

# ### foreman_user
# Sets the user under which foreman will execute the service. Defaults to *user*

# ### foreman_log
# Sets the foreman log path. Defaults to *shared/log*

set_default :foreman_app,  lambda { application }
set_default :foreman_user, lambda { user }
set_default :foreman_log,  lambda { "#{deploy_to!}/#{shared_path}/log" }
set_default :foreman_sudo, true
set_default :foreman_format, 'upstart'
set_default :foreman_location, '/etc/init'
set_default :foreman_procfile, 'Procfile'

namespace :foreman do
  desc 'Export the Procfile to Ubuntu upstart scripts'
  task :export do
    sudo_cmd = "sudo" if foreman_sudo
    export_cmd = "#{sudo_cmd} bundle exec foreman export #{foreman_format} #{foreman_location} -a #{foreman_app} -u #{foreman_user} -d #{deploy_to!}/#{current_path!} -l #{foreman_log} -f #{foreman_procfile}"

    queue %{
      echo "-----> Exporting foreman procfile for #{foreman_app}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; #{export_cmd}]}
    }
  end

  desc "Start the application services"
  task :start do
    queue %{
      echo "-----> Starting #{foreman_app} services"
      #{echo_cmd %[sudo start #{foreman_app}]}
    }
  end

  desc "Stop the application services"
  task :stop do
    queue %{
      echo "-----> Stopping #{foreman_app} services"
      #{echo_cmd %[sudo stop #{foreman_app}]}
    }
  end

  desc "Restart the application services"
  task :restart do
    queue %{
      echo "-----> Restarting #{foreman_app} services"
      #{echo_cmd %[sudo start #{foreman_app} || sudo restart #{foreman_app}]}
    }
  end
end
