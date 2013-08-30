# # Modules: rbenv
# Adds settings and tasks for managing [rbenv] installations.
#
# [rbenv]: https://github.com/sstephenson/rbenv
#
#     require 'mina/rbenv'
#
# ## Common usage
#
#     task :environment do
#       invoke :'rbenv:load'
#     end
#
#     task :deploy => :environment do
#       ...
#     end

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### rbenv_path
# Sets the path where *rbenv* is installed.
#
# You may override this if rbenv is placed elsewhere in your setup.

set_default :rbenv_path, "$HOME/.rbenv"

# ## Tasks

# ### rbenv:load
# Loads the *rbenv* runtime.

task :'rbenv:load' do
  queue %{
    echo "-----> Loading rbenv"
    #{echo_cmd %{export RBENV_ROOT="#{rbenv_path}"}}
    #{echo_cmd %{export PATH="#{rbenv_path}/bin:$PATH"}}

    if ! which rbenv >/dev/null; then
      echo "! rbenv not found"
      echo "! If rbenv is installed, check your :rbenv_path setting."
      exit 1
    fi

    #{echo_cmd %{eval "$(rbenv init -)"}}
  }
end
