# Common usage:
#
#     task :environment do
#       invoke :'rbenv:load'
#     end
#
#     task :deploy => :environment do
#       ...
#     end
#
set_default :rbenv_path, "$HOME/.rbenv"

task :'rbenv:load' do
  queue %{
    echo "-----> Loading rbenv"
    #{echo_cmd %{export PATH="#{rbenv_path}/bin:$PATH"}}

    # Ensure that rbenv is loaded.
    if ! which -s rbenv >/dev/null; then
      echo "! rbenv not found"
      echo "! If rbenv is installed, check your 'rbenv_path' setting"
    fi

    #{echo_cmd %{eval "$(rbenv init -)"}}
  }
end
