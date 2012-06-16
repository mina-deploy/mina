set_default :bash_options, '-i'

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
  FileUtils.cp Mina.root_path('data/deploy.rb'), './config/deploy.rb'

  puts 'Created deploy.rb.'
  puts "Edit it, then run `#{name} setup` after."
end

task :default => :help

module HelpHelpers
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

  SYSTEM_TASKS = %w[help tasks init]
  def system_tasks() get_tasks { |t| SYSTEM_TASKS.include? t.name }; end
  def top_tasks()    get_tasks { |t| ! t.name.include?(':') && t.comment && !system_tasks.include?(t) }; end
  def sub_tasks()    get_tasks { |t| t.name.include?(':') }; end

  def show_task_help(options={})
    puts "Basic usage:"
    print_tasks system_tasks

    if top_tasks.any?
      puts "\nServer tasks:"
      print_tasks top_tasks
    end

    if sub_tasks.any? && options[:full]
      puts "\nMore tasks:"
      print_tasks sub_tasks
    end
  end
end

extend HelpHelpers

desc "Show help."
task :help do
  name = Rake.application.name

  puts "#{name} - Really fast server deployment and automation tool\n\n"
  puts "Options:"

  opts = [
    [ "-h, --help", "Show help" ],
    [ "-V, --version", "Show program version" ],
    [ "-v, --verbose", "Show commands as they happen" ],
    [ "-S, --simulate", "Run in simulation mode" ],
    [ "-t, --trace", "Show backtraces when errors occur" ],
    [ "-f FILE", "Use FILE as the deploy configuration" ]
  ]
  opts.each { |args| puts "  %-17s %s" % args }
  puts ""

  show_task_help

  unless Rake.application.have_rakefile
    puts ""
    puts "Run this command in a project with a 'config/deploy.rb' file to see more options."
  end

  puts ""
  puts "All of Rake's options are also available as '#{name}' options. See 'rake --help'"
  puts "for more information."
end

desc "Show all tasks."
task :tasks do
  show_task_help :full => true
end
