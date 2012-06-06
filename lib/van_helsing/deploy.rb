set_default :releases_path, "releases"
set_default :shared_path, "shared"
set_default :current_path, "current"
set_default :lock_file, "deploy.lock"

namespace :deploy do
  desc "Forces a deploy unlock."
  task :force_unlock do
    queue %{echo "-----> Unlocking"}
    queue echo_cmd %{rm -f "#{deploy_to}/#{lock_file}"}
  end

  desc "Links paths set in :shared_paths."
  task :link_shared_paths do
    dirs = settings.shared_paths!.map { |file| File.dirname("./#{file}") }.uniq

    cmds = dirs.map do |dir|
      echo_cmd %{mkdir -p "#{dir}"}
    end

    cmds += shared_paths.map do |file|
      echo_cmd %{ln -s "#{shared_path}/#{file}" "./#{file}"}
    end

    queue %{
      echo "-----> Symlinking shared paths"
      #{cmds.join(" &&\n")}
    }
  end
end

desc "Sets up a site."
task :setup do
  settings.deploy_to!

  queue %{echo "-----> Setting up #{deploy_to}"}
  queue echo_cmd %{mkdir -p "#{deploy_to}"}
  queue echo_cmd %{chown -R `whoami` "#{deploy_to}"}
  queue echo_cmd %{chmod g+rx,u+rwx "#{deploy_to}"}
  queue echo_cmd %{cd "#{deploy_to}"}
  queue echo_cmd %{mkdir -p "#{releases_path}"}
  queue echo_cmd %{chmod g+rx,u+rwx "#{releases_path}"}
  queue echo_cmd %{mkdir -p "#{shared_path}"}
  queue echo_cmd %{chmod g+rx,u+rwx "#{shared_path}"}
  queue %{echo "-----> Done"}
end

desc "Runs a command in the server."
task :run, :command do |t, args|
  command = args[:command]
  unless command
    puts %[You need to provide a command. Try: vh "run[ls -la]"]
    exit 1
  end

  queue %[cd #{deploy_to} && #{command}]
end
