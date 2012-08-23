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
#
set_default :rvm_path, "$HOME/.rvm/scripts/rvm"

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
    #{echo_cmd %{rvm use "#{args[:env]}"}} || exit 1
  }
end
