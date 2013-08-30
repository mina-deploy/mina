# # Modules: RVM
# Adds settings and tasks for managing [RVM] installations.
#
# [rvm]: http://rvm.io
#
#     require 'mina/rvm'
#
# ## Common usage
#
#     task :environment do
#       invoke :'rvm:use[ruby-1.9.3-p125@gemset_name]'
#     end
#
#     task :deploy => :environment do
#       ...
#     end

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### rvm_path
# Sets the path to RVM.
#
# You can override this in your projects if RVM is installed in a different
# path, say, if you have a system-wide RVM install.

set_default :rvm_path, "$HOME/.rvm/scripts/rvm"

# ## Tasks

# ### rvm:use[]
# Uses a given RVM environment provided as an argument.
#
# This is usually placed in the `:environment` task.
#
#     task :environment do
#       invoke :'rvm:use[ruby-1.9.3-p125@gemset_name]'
#     end
#
task :'rvm:use', :env do |t, args|
  unless args[:env]
    print_error "Task 'rvm:use' needs an RVM environment name as an argument."
    print_error "Example: invoke :'rvm:use[ruby-1.9.2@default]'"
    die
  end

  queue %{
    echo "-----> Using RVM environment '#{args[:env]}'"
    if [[ ! -s "#{rvm_path}" ]]; then
      echo "! Ruby Version Manager not found"
      echo "! If RVM is installed, check your :rvm_path setting."
      exit 1
    fi

    source #{rvm_path}
    #{echo_cmd %{rvm use "#{args[:env]}" --create}} || exit 1
  }
end

# ### rvm:wrapper[]
# Creates a rvm wrapper for a given executable.
#
# This is usually placed in the `:setup` task.
#
#     task ::setup => :environment do
#       ...
#       invoke :'rvm:wrapper[ruby-1.9.3-p125@gemset_name,wrapper_name,binary_name]'
#     end
#
task :'rvm:wrapper', :env, :name, :bin do |t,args|
  unless args[:env] && args[:name] && args[:bin]
    print_error "Task 'rvm:wrapper' needs an RVM environment name, an wrapper name and the binary name as arguments"
    print_error "Example: invoke :'rvm:wrapper[ruby-1.9.2@myapp,myapp,unicorn_rails]'"
    die
  end

  queue %{
    echo "-----> creating RVM wrapper '#{args[:name]}_#{args[:bin]}' using '#{args[:env]}'"
    if [[ ! -s "#{rvm_path}" ]]; then
      echo "! Ruby Version Manager not found"
      echo "! If RVM is installed, check your :rvm_path setting."
      exit 1
    fi

    source #{rvm_path}
    #{echo_cmd %{rvm wrapper #{args[:env]} #{args[:name]} #{args[:bin]} }} || exit 1
  }
end