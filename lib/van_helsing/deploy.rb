settings.releases_path ||= "releases"
settings.shared_path   ||= "shared"
settings.current_path  ||= "current"
settings.lock_file     ||= "deploy.lock"

namespace :deploy do
  desc "Forces a deploy unlock."
  task :force_unlock do
    queue %{echo "-----> Unlocking"}
    queue echo_cmd %{rm -f "#{lock_file}"}
  end

  desc "Links paths set in :shared_paths."
  task :link_shared_paths do
    dirs = settings.shared_paths!.map { |file| File.dirname("./#{file}") }.uniq

    cmds = dirs.map do |dir|
      %{mkdir -p "#{dir}"}
    end

    cmds += shared_paths.map do |file|
      %{ln -s "#{shared_path}/#{file}" "./#{file}"}
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

  queue %{echo "-----> Setting up"}
  queue echo_cmd %{mkdir -p "#{deploy_to}"}
  queue echo_cmd %{chown -R `whoami` "#{deploy_to}"}
  queue echo_cmd %{chmod g+rx,u+rwx "#{deploy_to}"}
  queue echo_cmd %{mkdir -p "#{releases_path}"}
  queue echo_cmd %{chmod g+rx,u+rwx "#{releases_path}"}
  queue echo_cmd %{mkdir -p "#{shared_path}"}
  queue echo_cmd %{chmod g+rx,u+rwx "#{shared_path}"}
end
