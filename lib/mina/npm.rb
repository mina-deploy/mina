# # Modules: Npm
# Adds settings and tasks for managing Node packages.
#
#     require 'mina/npm'

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### npm_bin
# Sets the npm binary.

set_default :npm_bin, 'npm'

# ### bower_bin
# Sets the bower binary.

set_default :bower_bin, 'bower'

# ### grunt_bin
# Sets the grunt binary.

set_default :grunt_bin, 'grunt'

# ### npm_options
# Sets the options for installing modules via npm.

set_default :npm_options, '--production'

# ### bower_options
# Sets the options for installing modules via bower.

set_default :bower_options, '--allow-root'

# ### grunt_options
# Sets the options for grunt.

set_default :grunt_options, ''

# ### grunt_task
# Sets the task parameters for grunt.

set_default :grunt_task, 'build'


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
      #{echo_cmd %[ln -s "#{deploy_to}/#{shared_path}/$sub_directory/node_modules" "node_modules"]}
      #{echo_cmd %[#{npm_bin} install #{npm_options}]}
    }
  end
end

namespace :bower do
  # ### bower:install
  # Installs bower modules. Takes into account if executed `in_directory` and namespaces the installed modules in the shared folder.
  desc "Install bower modules."
  task :install => :environment do
    queue %{
      echo "-----> Installing bower modules"
      sub_directory=$(pwd | sed -r "s/.*?$(basename $build_path)//g")
      #{echo_cmd %[mkdir -p "#{deploy_to}/#{shared_path}/$sub_directory/bower_components"]}
      #{echo_cmd %[ln -s "#{deploy_to}/#{shared_path}/$sub_directory/bower_components" "bower_components"]}
      #{echo_cmd %[[ -f bower.json ] && (#{bower_bin} install #{bower_options}) || ! [ -f bower.json ]]}
    }
  end
end

namespace :grunt do
  # ### grunt:install
  # Launch a task with grunt. Set the grunt_task (defaults to \"build\") variable before calling this.
  desc "Launch a task with grunt. Set the grunt_task (defaults to \"build\") variable before calling this."
  task :task => :environment do
    queue %{
      echo "-----> Launch a build with Grunt"
      #{echo_cmd %[[ -f Gruntfile.js ] && (#{grunt_bin} #{grunt_task} #{grunt_options}) || ! [ -f Gruntfile.js ]]}
    }
  end
end
