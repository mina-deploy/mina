require 'mina/default'

set :releases_path, 'releases'
set :shared_path, 'shared'
set :current_path, 'current'
set :lock_file, 'deploy.lock'
set :keep_releases, 5
set :execution_mode, :pretty

namespace :deploy do
  desc 'Forces a deploy unlock.'
  task :force_unlock do
    comment 'Unlocking'
    command "rm -f '#{fetch(:deploy_to)}/#{fetch(:lock_file)}'"
  end

  desc 'Links paths set in :shared_paths.'
  task :link_shared_paths do
    dirs = fetch(:shared_paths, []).map { |file| File.dirname("./#{file}") }.uniq

    comment 'Symlinking shared paths'

    dirs.each { |dir| command "mkdir -p '#{dir}'" }

    fetch(:shared_paths, []).each do |file|
      command "ln -nFs '#{fetch(:deploy_to)}/#{fetch(:shared_path)}/#{file}' './#{file}'"
    end
  end

  desc 'Clean up old releases.'
  task :cleanup do
    ensure!(:keep_releases)
    ensure!(:deploy_to)

    comment "Cleaning up old releases (keeping #{fetch(:keep_releases)})"
    command "cd '#{fetch(:deploy_to)}/#{fetch(:releases_path)}' || exit 15"
    command 'count=`ls -1 | sort -rn | wc -l`'
    command "remove=$((count > #{fetch(:keep_releases)} ? count - #{fetch(:keep_releases)} : 0))"
    command 'ls -1 | sort -rn | tail -n $remove | xargs rm -rf {}'
  end

  desc 'Rollbacks the latest release'
  task rollback: :environment do
    comment "Rolling back to previous release for instance: #{fetch(:domain)}"

    # Delete existing sym link and create a new symlink pointing to the previous release
    comment 'Creating new symlink from the previous release: '
    command "ls -Art '#{fetch(:deploy_to)}/#{fetch(:releases_path)}' | sort | tail -n 2 | head -n 1"
    command "ls -Art '#{fetch(:deploy_to)}/#{fetch(:releases_path)}' | sort | tail -n 2 | head -n 1 | xargs -I active ln -nfs '#{fetch(:deploy_to)}/#{fetch(:releases_path)}/active' '#{fetch(:deploy_to)}/#{fetch(:current_path)}'"

    # Remove latest release folder (current release)
    comment 'Deleting current release: '
    command "ls -Art '#{fetch(:deploy_to)}/#{fetch(:releases_path)}' | sort | tail -n 1"
    command "ls -Art '#{fetch(:deploy_to)}/#{fetch(:releases_path)}' | sort | tail -n 1 | xargs -I active rm -rf '#{fetch(:deploy_to)}/#{fetch(:releases_path)}/active'"
  end
end

desc 'Sets up a site.'
task :setup do
  ensure!(:deploy_to)

  comment "Setting up #{fetch(:deploy_to)}"
  command "mkdir -p '#{fetch(:deploy_to)}'"
  command "chown -R `whoami` '#{fetch(:deploy_to)}'"
  command "chmod g+rx,u+rwx '#{fetch(:deploy_to)}'"
  command "cd '#{fetch(:deploy_to)}'"
  command "mkdir -p '#{fetch(:releases_path)}'"
  command "chmod g+rx,u+rwx '#{fetch(:releases_path)}'"
  command "mkdir -p '#{fetch(:shared_path)}'"
  command "chmod g+rx,u+rwx '#{fetch(:shared_path)}'"
  command 'echo ""'
  command "tree '#{fetch(:deploy_to)}' || ls -al '#{fetch(:deploy_to)}'"
  command 'echo ""'
  comment 'Done'
end
