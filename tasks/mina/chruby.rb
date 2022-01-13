# frozen_string_literal: true

unless fetch(:silence_deprecation_warnings)
  warn '[DEPRECATION] chruby support will be removed from Mina in v2.0.0.'
  warn '[DEPRECATION] To continue using chruby tasks, install `mina-version_managers` gem and'
  warn "[DEPRECATION] replace `require 'mina/chruby'` with `require 'mina/version_managers/chruby'`."
  warn '[DEPRECATION] See https://github.com/mina-deploy/mina-version_managers for more info.'
  warn '[DEPRECATION] You can silence this message by adding `set :silence_deprecation_warnings, true` to `config/deploy.rb`.'
  warn ''
end

set :chruby_path, '/etc/profile.d/chruby.sh'

task :chruby, :env do |_, args|
  unless args[:env]
    puts "Task 'chruby' needs a Ruby version as an argument."
    puts "Example: invoke :chruby, 'ruby-2.4'"
    exit 1
  end

  comment %(chruby to version: \\"#{args[:env]}\\")
  command %(
    if [[ ! -s "#{fetch(:chruby_path)}" ]]; then
      echo "! chruby.sh init file not found"
      exit 1
    fi
  )
  command %(source #{fetch(:chruby_path)})
  command %(chruby "#{args[:env]}" || exit 1)
end
