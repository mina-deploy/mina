# Default tasks here
desc "Creates a sample config file."
task :init do
  name = Rake.application.name
  config_file = Rake.application.rakefile

  unless config_file.to_s.empty?
    error "You already have #{config_file}."
    exit 8
  end

  require 'fileutils'
  FileUtils.mkdir_p './config'
  FileUtils.cp VanHelsing.root_path('data/deploy.rb'), './config/deploy.rb'

  puts 'Created deploy.rb.'
  puts 'Edit it, then run `#{name} setup` after.'
end

task :default => :help

def get_tasks(&blk)
  Rake.application.tasks.select &blk
end

def print_tasks(tasks, width=nil)
  name = Rake.application.name

  width ||= tasks.map { |t| t.name_with_args.length }.max || 10
  tasks.each do |t|
    if t.comment
      puts "  #{name} %-#{width}s   # %s" % [ t.name_with_args, t.comment ]
    else
      puts "  #{name} %s" % [ t.name_with_args ]
    end
  end
end

desc "Show help."
task :help do
  name = Rake.application.name

  top_tasks = get_tasks { |t| (! t.name.include? ':') && t.name != 'default' }
  top_tasks = top_tasks.reject { |t| t.name == 'init' }  if Rake.application.have_rakefile

  puts "#{name} - Really fast server deployment and automation tool"

  puts "Usage:\n\n"
  print_tasks top_tasks
end

desc "Show all tasks."
task :tasks do
  sub_tasks = get_tasks { |t| t.name.include? ':' }
  top_tasks = get_tasks { |t| (! t.name.include? ':') && t.name != 'default' }
  top_tasks = top_tasks.reject { |t| t.name == 'init' }  if Rake.application.have_rakefile

  puts "Top-level tasks:"
  print_tasks top_tasks

  if sub_tasks.any?
    puts "\nMore tasks:"
    print_tasks sub_tasks
  end
end
