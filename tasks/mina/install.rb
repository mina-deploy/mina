desc 'Creates a sample config file.'
task :init do
  name = Rake.application.name
  config_file = Rake.application.rakefile

  unless File.exist?(config_file)
    puts "! You already have #{config_file}."
    exit 8
  end

  outfile = './config/deploy.rb'
  require 'fileutils'
  FileUtils.mkdir_p './config'
  FileUtils.cp Mina.root_path('data/deploy.rb'), outfile

  puts "-----> Created #{outfile}"
  puts "Edit this file, then run `#{name} setup` after."
end
