# frozen_string_literal: true

unless fetch(:silence_deprecation_warnings)
  warn '[DEPRECATION] ry support will be removed from Mina in v2.0.0.'
  warn '[DEPRECATION] To continue using ry tasks, install `mina-version_managers` gem and'
  warn "[DEPRECATION] replace `require 'mina/ry'` with `require 'mina/version_managers/ry'`."
  warn '[DEPRECATION] See https://github.com/mina-deploy/mina-version_managers for more info.'
  warn '[DEPRECATION] You can silence this message by adding `set :silence_deprecation_warnings, true` to `config/deploy.rb`.'
  warn ''
end

set :ry_path, '$HOME/.local'

task :ry, :env do |_, args|
  puts "Task 'ry' without argument will use default Ruby version." unless args[:env]

  comment %(ry to version: \\"#{args[:env] || '**not specified**'}\\")
  comment %(Loading ry)

  command %(
    if [[ ! -e "#{fetch(:ry_path)}/bin" ]]; then
      echo "! ry not found"
      echo "! If ry is installed, check your :ry_path setting."
      exit 1
    fi
  )
  command %(export PATH="#{fetch(:ry_path)}/bin:$PATH")
  command %{eval "$(ry setup)"}
  command %(RY_RUBY="#{args[:env]}")
  command %(
    if [ -n "$RY_RUBY" ]; then
      #{echo_cmd 'ry use $RY_RUBY'} || exit 1
    fi
  )
end
