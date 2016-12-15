require 'mina/install'

set :port, 22

task :environment do
end

task :default do
end

task :run_commands do
  if commands.run_default?
    invoke :environment
    commands.run(:remote)
  end
end

task :reset! do
  reset!
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

desc 'Adds current repo host to the known hosts'
task :ssh_keyscan_repo do
  ensure!(:repository)
  repo_host = fetch(:repository).split(%r{@|://}).last.split(%r{:|\/}).first
  repo_port = /:([0-9]+)/.match(fetch(:repository)) && /:([0-9]+)/.match(fetch(:repository))[1] || '22'

  next if repo_host == ""

  command %{
    if ! ssh-keygen -H -F #{repo_host} &>/dev/null; then
      ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
    fi
  }
end

desc 'Adds domain known hosts'
task :ssh_keyscan_domain do
  ensure!(:domain)
  ensure!(:port)
  run :local do
    command %{
      if ! ssh-keygen -H -F #{fetch(:domain)} &>/dev/null; then
        ssh-keyscan -t rsa -p #{fetch(:port)} -H #{fetch(:domain)} >> ~/.ssh/known_hosts
      fi
    }
  end
end

desc 'Runs a command in the server.'
task :run, [:command] do |_, args|
  ensure!(:deploy_to)
  command = args[:command]

  unless command
    puts "You need to provide a command. Try: mina 'run[ls -la]'"
    exit 1
  end

  in_path fetch(:deploy_to) do
    command command
  end
end

desc 'Open an ssh session to the server and cd to deploy_to folder'
task :ssh do
  exec %{#{Mina::Backend::Remote.new(nil).ssh} 'cd #{fetch(:deploy_to)} && exec $SHELL'}
end
