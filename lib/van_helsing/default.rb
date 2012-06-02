# Default tasks here
desc "Creates a sample config file."
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

task :default => :help

desc "Show help."
task :help do
  name = Rake.application.name
  puts "#{name} - Really fast server deployment and automation tool"
  puts ""
  puts "Usage:"
  puts "  #{name} init      # Creates a sample Van Helsing config file."
  puts "  #{name} setup     # Sets up a server."
  puts ""
  puts "See '#{name} -T' for a full list of available tasks."
end
