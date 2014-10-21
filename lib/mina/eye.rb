# # Modules: eye
# Adds settings and tasks for managing [eye].
# 
# [eye]: https://github.com/kostya/eye
# 
# ## Common usage
#
#     task :deploy => :environment do
#       ...
#       
#       to :launch do 
#         invoke :'eye:load'
#         invoke :'eye:restart'
#       end
#     end
#
# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.
# 
# ### eye_bin
# Sets the path where *eye* is installed. 
set_default :eye_bin, '/usr/local/bin/eye'

# ### eye_config
# Sets the path where *eye.conf* is installed. 
set_default :eye_config, "#{deploy_to}/current/config/eye.conf"

# ### eye_app
# Sets the symbolic name of the app from *eye.conf*.
set_default :eye_app, domain

# ### Tasks
namespace :eye do
  
  # ### eye:load 
  # Loads *eye.conf* to eye.
  task :load => :environment do
    queue! "#{eye_bin} load #{eye_config}"
  end

  # ### eye:start 
  # Starts servers and workers described in the *eye.conf*.
  task :start => :environment do
    queue! "#{eye_bin} start #{eye_app}"
  end

  # ### eye:stop
  # Stops servers and workers described in the *eye.conf*.
  task :stop => :environment do
    queue! "#{eye_bin} stop #{eye_app}"
  end
  
  # ### eye:restart
  # Restarts servers and workers described in the *eye.conf*.
  task :restart => :environment do
    queue! "#{eye_bin} restart #{eye_app}"
  end

  # ### eye:delere 
  # Deletes *eye_app* from watching list.
  task :delete => :environment do
    queue! "#{eye_bin} delete #{eye_app}"
  end
end
