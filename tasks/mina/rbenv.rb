set :rbenv_path, "$HOME/.rbenv"

task :'rbenv:load' do
  comment %{Loading rbenv}
  command %{export RBENV_ROOT="#{fetch(:rbenv_path)}"}
  command %{export PATH="#{fetch(:rbenv_path)}/bin:$PATH"}
  command %{
    if ! which rbenv >/dev/null; then
      echo "! rbenv not found"
      echo "! If rbenv is installed, check your :rbenv_path setting."
      exit 1
    fi
  }
  command %{eval "$(rbenv init -)"}
end
