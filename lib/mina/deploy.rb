set_default :releases_path, "releases"
set_default :shared_path, "shared"
set_default :current_path, "current"
set_default :lock_file, "deploy.lock"
set_default :keep_releases, 5

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
      [
        echo_cmd(%{rm -rf "./#{file}"}),
        echo_cmd(%{ln -s "#{deploy_to}/#{shared_path}/#{file}" "./#{file}"})
      ]
    end

    queue %{
      echo "-----> Symlinking shared paths"
      #{cmds.flatten.join(" &&\n")}
    }
  end

  desc "Clean up old releases. By default, the last 5 releases are kept on
    each server (though you can change this with the keep_releases setting).
    All other deployed revisions are removed from the servers."
  task :cleanup do
    queue %{echo "-----> Cleaning up old releases (keeping #{keep_releases!})"}
    queue echo_cmd %{cd "#{deploy_to!}" || exit 15}
    queue echo_cmd %{cd "#{releases_path!}" || exit 16}
    queue echo_cmd %{count=`ls -1d [0-9]* | sort -rn | wc -l`}
    queue echo_cmd %{remove=$((count > 5 ? count - #{keep_releases} : 0))}
    queue echo_cmd %{ls -1d [0-9]* | sort -rn | tail -n $remove | xargs rm -rf {}}
  end
end

desc "Sets up a site."
task :setup do
  set :term_mode, :pretty

  settings.deploy_to!

  user = settings.user? ? "#{settings.user}" : "username"

  queue %{
    echo "-----> Setting up #{deploy_to}" && (
      #{echo_cmd %{mkdir -p "#{deploy_to}"}} &&
      #{echo_cmd %{chown -R `whoami` "#{deploy_to}"}} &&
      #{echo_cmd %{chmod g+rx,u+rwx "#{deploy_to}"}} &&
      #{echo_cmd %{cd "#{deploy_to}"}} &&
      #{echo_cmd %{mkdir -p "#{releases_path}"}} &&
      #{echo_cmd %{chmod g+rx,u+rwx "#{releases_path}"}} &&
      #{echo_cmd %{mkdir -p "#{shared_path}"}} &&
      #{echo_cmd %{chmod g+rx,u+rwx "#{shared_path}"}} &&
      echo "" &&
      #{echo_cmd %{ls -la "#{deploy_to}"}} &&
      echo "" &&
      echo "-----> Done."
    ) || (
      echo "! ERROR: Setup failed."
      echo "! Ensure that the path '#{deploy_to}' is accessible to the SSH user."
      echo "! Try doing:"
      echo "!    sudo mkdir -p \\"#{deploy_to}\\" && sudo chown -R #{user} \\"#{deploy_to}\\""
    )
  }
end

desc "Runs a command in the server."
task :run, :command do |t, args|
  command = args[:command]
  unless command
    puts %[You need to provide a command. Try: mina "run[ls -la]"]
    exit 1
  end

  queue %[cd #{deploy_to!} && #{command}]
end
