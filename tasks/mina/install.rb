# frozen_string_literal: true

desc 'Creates a sample config file.'
task :init do
  name = Rake.application.name
  config_file = Rake.application.rakefile

  unless File.exist?(config_file)
    puts "! You already have #{config_file}."
    exit 8
  end

  outfile = './config/deploy.rb'

  if File.exist?(outfile)
    print 'deploy.rb already exists, do you want to overwrite it? (y/n) '

    exit(8) if $stdin.readline.chomp.downcase != 'y'
  end

  require 'fileutils'
  FileUtils.mkdir_p './config'
  FileUtils.cp Mina.root_path('data/deploy.rb'), outfile

  puts "-----> Created #{outfile}"
  puts "Edit this file, then run `#{name} setup` after."
end
