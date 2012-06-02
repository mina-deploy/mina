namespace :deploy do
  desc "Forces a deploy unlock."
  task :force_unlock do
    queue %{echo "-----> Unlocking"}
    queue %{rm -f "#{deploy_to}/deploy.lock"}
    queue %{exit 234}
    run!
  end

  desc "Links paths set in :shared_paths."
  task :link_shared_paths do
    validate_set :shared_paths

    dirs = shared_paths.map { |file| File.dirname("#{release_path}/#{file}") }.uniq

    cmds = dirs.map do |dir|
      %{mkdir -p "#{dir}"}
    end

    cmds += shared_paths.map do |file|
      %{ln -s "#{shared_path}/#{file}" "#{release_path}/#{file}"}
    end

    queue %{
      echo "-----> Symlinking shared paths"
      #{cmds.join(" &&\n")}
    }
  end
end
