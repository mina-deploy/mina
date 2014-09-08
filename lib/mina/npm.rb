# # Modules: Npm
# Adds settings and tasks for managing Node packages.
#
#     require 'mina/npm'

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### npm_bin
# Sets the npm binary.

set_default :npm_bin, 'npm'

# ### npm_options
# Sets the options for installing modules via npm.

set_default :npm_options, lambda { %{--production} }

# ## Deploy tasks
# These tasks are meant to be invoked inside deploy scripts, not invoked on
# their own.

namespace :npm do
  # ### npm:install
  # Installs node modules. Takes into account if executed `in_directory` and namespaces the installed modules in the shared folder.
  desc "Install node modules using Npm."
  task :install => :environment do
    queue %{
      echo "-----> Installing node modules using Npm"
      sub_directory=$(pwd | sed -r "s/.*?$(basename $build_path)//g")
      #{echo_cmd %[mkdir -p "#{deploy_to}/#{shared_path}/$sub_directory/node_modules"]}
      #{echo_cmd %[ln -s "#{deploy_to}/#{shared_path}/$sub_directory/node_modules/" "node_modules"]}
      #{echo_cmd %[#{npm_bin} install #{npm_options}]}
    }
  end
end
