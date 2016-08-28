require 'mina/default'

set :releases_path, -> { "#{fetch(:deploy_to)}/releases" }
set :shared_path, -> { "#{fetch(:deploy_to)}/shared" }
set :current_path, -> { "#{fetch(:deploy_to)}/current" }
set :lock_file, 'deploy.lock'
set :deploy_script, 'data/deploy.sh.erb'
set :keep_releases, 5
set :version_scheme, :sequence
set :execution_mode, :pretty

namespace :deploy do
  desc 'Forces a deploy unlock.'
  task force_unlock: :environment do
    comment %(Unlocking)
    command %(rm -f "#{fetch(:deploy_to)}/#{fetch(:lock_file)}")
  end

  desc 'Links paths set in :shared_dirs and :shared_files.'
  task link_shared_paths: :environment do
    comment %(Symlinking shared paths)

    fetch(:shared_dirs, []).each do |linked_dir|
      command %(mkdir -p #{File.dirname("./#{linked_dir}")})
      command %(rm -rf "./#{linked_dir}")
      command %(ln -s "#{fetch(:shared_path)}/#{linked_dir}" "./#{linked_dir}")
    end

    fetch(:shared_files, []).each do |linked_path|
      command %(ln -s "#{fetch(:shared_path)}/#{linked_path}" "./#{linked_path}")
    end
  end

  desc 'Clean up old releases.'
  task cleanup: :environment do
    ensure!(:keep_releases)
    ensure!(:deploy_to)

    comment %(Cleaning up old releases (keeping #{fetch(:keep_releases)}))
    in_path "#{fetch(:releases_path)}" do
      command %(count=$(ls -A1 | sort -rn | wc -l))
      command %(remove=$((count > #{fetch(:keep_releases)} ? count - #{fetch(:keep_releases)} : 0)))
      command %(ls -A1 | sort -rn | tail -n $remove | xargs rm -rf {})
    end
  end
end

desc 'Rollbacks the latest release'
task rollback: :environment do
  comment %(Rolling back to previous release)

  in_path "#{fetch(:releases_path)}" do
    # TODO: add check if there are more than 1 release
    command %(rollback_release=$(ls -1A | sort -n | tail -n 2 | head -n 1))
    comment %(Rollbacking to release: $rollback_release)
    command %(ln -nfs #{fetch(:releases_path)}/$rollback_release #{fetch(:current_path)})
    command %(current_release=$(ls -1A | sort -n | tail -n 1))
    comment %(Deleting current release: $current_release)
    command %(rm -rf #{fetch(:releases_path)}/$current_release)
  end
end

desc 'Sets up a site.'
task setup: :environment do
  ensure!(:deploy_to)

  comment %(Setting up #{fetch(:deploy_to)})
  command %(mkdir -p "#{fetch(:deploy_to)}")
  command %(chown -R $(whoami) "#{fetch(:deploy_to)}")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}")
  command %(mkdir -p "#{fetch(:releases_path)}")
  command %(chmod g+rx,u+rwx "#{fetch(:releases_path)}")
  command %(mkdir -p "#{fetch(:shared_path)}")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}")

  in_path "#{fetch(:shared_path)}" do
    fetch(:shared_dirs, []).each do |linked_dir|
      command %(mkdir -p "#{linked_dir}")
      command %(chmod g+rx,u+rwx "#{linked_dir}")
    end
    fetch(:shared_paths, []).each do |linked_path|
      command %(mkdir -p "#{File.dirname(linked_path)}")
      command %(chmod g+rx,u+rwx "#{File.dirname(linked_path)}")
    end
  end

  command %(tree "#{fetch(:deploy_to)}" || ls -al "#{fetch(:deploy_to)}")

  invoke :ssh_keyscan
end
