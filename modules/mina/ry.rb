# # Modules: ry
# Adds settings and tasks for managing [ry] installations.
#
# [ry]: https://github.com/jneen/ry
#
#     require 'mina/ry'
#
# ## Common usage
#
#     task :environment do
#       invoke :'ry[ruby-1.9.3-p392]'
#       # or without parameter to use default ruby version
#       invoke :'ry'
#     end
#
#     task :deploy => :environment do
#       ...
#     end

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### ry_path
# Path where *ry* init scripts are installed.
#
set_default :ry_path, "$HOME/.local"

# ## Tasks

# ### ry[version]
# Switch to given Ruby version

task :ry, :env do |t, args|
  unless args[:env]
    print_status "Task 'ry' without argument will use default Ruby version."
  end

  queue %{
    echo "-----> ry to version: '#{args[:env] || '**not specified**'}'"

    echo "-----> Loading ry"
    if [[ ! -e "#{ry_path}/bin" ]]; then
      echo "! ry not found"
      echo "! If ry is installed, check your :ry_path setting."
      exit 1
    fi
    #{echo_cmd %{export PATH="#{ry_path}/bin:$PATH"}}
    #{echo_cmd %{eval "$(ry setup)"}}

    RY_RUBY="#{args[:env]}"
    if [ -n "$RY_RUBY" ]; then
      #{echo_cmd %{ry use $RY_RUBY}} || exit 1
    fi
  }
end
