# # Modules: Foreman
# Adds settings and tasks for managing projects with [foreman].
# NOTE: Requires sudo privileges
# [foreman]: http://rubygems.org/ddolar/foreman

set_default :foreman_app,  lambda { application }
set_default :foreman_user, lambda { user }
set_default :foreman_log,  lambda { "#{deploy_to!}/#{shared_path}/log" }

namespace :foreman do
  desc 'Export the Procfile to Ubuntu upstart scripts'
  task :export do
    export_cmd = "sudo bundle exec foreman export upstart /etc/init -a #{foreman_app} -u #{foreman_user} -l #{foreman_log}"

    queue %{
      echo "-----> Exporting foreman procfile for #{foreman_app}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; #{export_cmd}]}
    }
  end

  desc "Start the application services"
  task :start do
    queue %{
      echo "-----> Starting #{foreman_app} services"
      #{echo_cmd %[sudo "start #{foreman_app}"]}
    }
  end

  desc "Stop the application services"
  task :stop do
    queue %{
      echo "-----> Starting #{foreman_app} services"
      #{echo_cmd %[sudo "start #{foreman_app}"]}
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