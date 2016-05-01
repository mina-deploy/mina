# # Modules: chruby
# Adds settings and tasks for managing [chruby] installations.
#
# [chruby]: https://github.com/postmodern/chruby
#
#     require 'mina/chruby'
#
# ## Common usage
#
#     task :environment do
#       invoke :'chruby[ruby-1.9.3-p392]'
#     end
#
#     task :deploy => :environment do
#       ...
#     end

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### chruby_path
# Path where *chruby* init scripts are installed.
#
set_default :chruby_path, "/etc/profile.d/chruby.sh"

# ## Tasks

# ### chruby[version]
# Switch to given Ruby version

task :chruby, :env do |t, args|
  unless args[:env]
    print_error "Task 'chruby' needs a Ruby version as an argument."
    print_error "Example: invoke :'chruby[ruby-1.9.3-p392]'"
    die
  end

  queue %{
    echo "-----> chruby to version: '#{args[:env]}'"

    if [[ ! -s "#{chruby_path}" ]]; then
      echo "! chruby.sh init file not found"
      exit 1
    fi

    source #{chruby_path}
    #{echo_cmd %{chruby "#{args[:env]}"}} || exit 1
  }
end
