# frozen_string_literal: true

unless fetch(:silence_deprecation_warnings)
  warn '[DEPRECATION] rbenv support will be removed from Mina in v2.0.0.'
  warn '[DEPRECATION] To continue using rbenv tasks, install `mina-version_managers` gem and'
  warn "[DEPRECATION] replace `require 'mina/rbenv'` with `require 'mina/version_managers/rbenv'`."
  warn '[DEPRECATION] See https://github.com/mina-deploy/mina-version_managers for more info.'
  warn '[DEPRECATION] You can silence this message by adding `set :silence_deprecation_warnings, true` to `config/deploy.rb`.'
  warn ''
end

set :rbenv_path, '$HOME/.rbenv'

task :'rbenv:load' do
  comment %(Loading rbenv)
  command %(export RBENV_ROOT="#{fetch(:rbenv_path)}")
  command %(export PATH="#{fetch(:rbenv_path)}/bin:$PATH")
  command %(
    if ! which rbenv >/dev/null; then
      echo "! rbenv not found"
      echo "! If rbenv is installed, check your :rbenv_path setting."
      exit 1
    fi
  )
  command %{eval "$(rbenv init -)"}
end
