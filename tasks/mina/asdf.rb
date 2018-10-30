set :asdf_path, "$HOME/.asdf"

task :'asdf:load' do
  comment %{Loading asdf}
  command %{. $HOME/.asdf/asdf.sh}
  command %{
    if ! which asdf >/dev/null; then
      echo "! asdf not found"
      echo "! If asdf is installed, check your :asdf_path setting."
      exit 1
    fi
  }
end