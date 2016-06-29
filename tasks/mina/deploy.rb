require 'mina/default'

set :releases_path, -> { "#{fetch(:deploy_to)}/releases" }
set :shared_path, -> { "#{fetch(:deploy_to)}/shared" }
set :current_path, -> { "#{fetch(:deploy_to)}/current" }
set :lock_file, 'deploy.lock'
set :deploy_script, 'data/deploy.sh.erb'
set :keep_releases, 5
set :execution_mode, :pretty

namespace :deploy do
  desc 'Forces a deploy unlock.'
  task force_unlock: :environment do
    comment 'Unlocking'
    command "rm -f '#{fetch(:deploy_to)}/#{fetch(:lock_file)}'"
  end

  desc 'Links paths set in :shared_dirs and :shared_files.'
  task link_shared_paths: :environment do
    comment 'Symlinking shared paths'

    fetch(:shared_dirs, []).each do |linked_dir|
      command %(mkdir -p #{File.dirname("./#{linked_dir}")})
      command "rm -rf './#{linked_dir}'"
      command "ln -s '#{fetch(:shared_path)}/#{linked_dir}' './#{linked_dir}'"
    end

    fetch(:shared_files, []).each do |linked_path|
      command "ln -s '#{fetch(:shared_path)}/#{linked_path}' './#{linked_path}'"
    end
  end

  desc 'Clean up old releases.'
  task cleanup: :environment do
    ensure!(:keep_releases)
    ensure!(:deploy_to)

    comment "Cleaning up old releases (keeping #{fetch(:keep_releases)})"
    in_path "#{fetch(:releases_path)}" do
      command 'count=`ls -1 | sort -rn | wc -l`'
      command "remove=$((count > #{fetch(:keep_releases)} ? $count - #{fetch(:keep_releases)} : 0))"
      command 'ls -1 | sort -rn | tail -n $remove | xargs rm -rf {}'
    end
  end
end

# TODO: Test this
#   desc 'Rollbacks the latest release'
#   task rollback: :environment do
#     comment "Rolling back to previous release for instance: #{fetch(:domain)}"
#
#     # Delete existing sym link and create a new symlink pointing to the previous release
#     comment 'Creating new symlink from the previous release: '
#     command "ls -Art '#{fetch(:releases_path)}' | sort | tail -n 2 | head -n 1"
#     command "ls -Art '#{fetch(:releases_path)}' | sort | tail -n 2 | head -n 1 | xargs -I active ln -nfs '#{fetch(:releases_path)}/active' '#{fetch(:current_path)}'"
#
#     # Remove latest release folder (current release)
#     comment 'Deleting current release: '
#     command "ls -Art '#{fetch(:releases_path)}' | sort | tail -n 1"
#     command "ls -Art '#{fetch(:releases_path)}' | sort | tail -n 1 | xargs -I active rm -rf '#{fetch(:releases_path)}/active'"
#   end
# end

desc 'Sets up a site.'
task setup: :environment do
  ensure!(:deploy_to)

  comment "Setting up #{fetch(:deploy_to)}"
  command "mkdir -p '#{fetch(:deploy_to)}'"
  command "chown -R `whoami` '#{fetch(:deploy_to)}'"
  command "chmod g+rx,u+rwx '#{fetch(:deploy_to)}'"
  command "mkdir -p '#{fetch(:releases_path)}'"
  command "chmod g+rx,u+rwx '#{fetch(:releases_path)}'"
  command "mkdir -p '#{fetch(:shared_path)}'"
  command "chmod g+rx,u+rwx '#{fetch(:shared_path)}'"

  in_path "#{fetch(:shared_path)}" do
    fetch(:shared_dirs, []).each do |linked_dir|
      command "mkdir -p '#{linked_dir}'"
      command "chmod g+rx,u+rwx '#{linked_dir}'"
    end
  end

  command "tree '#{fetch(:deploy_to)}' || ls -al '#{fetch(:deploy_to)}'"
end
