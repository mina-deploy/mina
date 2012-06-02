# Default tasks here
task :init do
  config_file = Rake.application.rakefile

  unless config_file.empty?
    error "You already have #{config_file}."
    exit 8
  end

  require 'fileutils'
  FileUtils.mkdir_p './config'
  FileUtils.cp VanHelsing.root_path('data/deploy.rb'), './config/deploy.rb'

  puts 'Created deploy.rb.'
  puts 'Edit it, then run `vh setup` after.'
end
