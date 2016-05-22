task :environment do
end

desc 'Run commands'
task :run_commands do
  run_commands
end

task :debug_configuration_variables do
  if fetch(:debug_configuration_variables)
    puts
    puts '------- Printing current config variables -------'
    configuration.variables.each do |key, value|
      puts "#{key.inspect} => #{value.inspect}"
    end
  end
end

desc 'Runs a command in the server.'
task :run, [:command] => [:environment] do |_, args|
  ensure!(:deploy_to)
  command = args[:command]

  unless command
    puts "You need to provide a command. Try: mina 'run[ls -la]'"
    exit 1
  end

  command "cd #{fetch(:deploy_to)} && #{command}"
end

desc 'Open an ssh session to the server and cd to deploy_to folder'
task :ssh do
  exec ssh_command + " 'cd #{deploy_to} && exec \$SHELL'"
end
