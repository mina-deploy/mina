set :nodenv_path, "$HOME/.nodenv"

task :'nodenv:load' do
  comment %{Loading nodenv}
  command %{export NODENV_ROOT="#{fetch(:nodenv_path)}"}
  command %{export PATH="#{fetch(:nodenv_path)}/bin:$PATH"}
  command %{
    if ! which nodenv >/dev/null; then
      echo "! nodenv not found"
      echo "! If nodenv is installed, check your :nodenv_path setting."
      exit 1
    fi
  }
  command %{eval "$(nodenv init -)"}
end
