set :ry_path, '$HOME/.local'

task :ry, :env do |_, args|
  unless args[:env]
    puts "Task 'ry' without argument will use default Ruby version."
  end

  comment %{ry to version: \\"#{args[:env] || '**not specified**'}\\"}
  comment %{Loading ry}

  command %{
    if [[ ! -e "#{fetch(:ry_path)}/bin" ]]; then
      echo "! ry not found"
      echo "! If ry is installed, check your :ry_path setting."
      exit 1
    fi
  }
  command %{export PATH="#{fetch(:ry_path)}/bin:$PATH"}
  command %{eval "$(ry setup)"}
  command %{RY_RUBY="#{args[:env]}"}
  command %{
    if [ -n "$RY_RUBY" ]; then
      #{echo_cmd 'ry use $RY_RUBY'} || exit 1
    fi
  }
end
