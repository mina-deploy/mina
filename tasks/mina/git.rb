require 'mina/default'

set :branch, 'master'

namespace :git do
  desc 'Clones the Git repository to the release path.'
  task clone: :environment do
    ensure!(:repository)
    ensure!(:deploy_to)
    if set?(:commit)
      comment "Using git commit '#{fetch(:commit)}'"
      command "git clone '#{fetch(:repository)}' . --recursive"
      command "git checkout -b current_release '#{fetch(:commit)}' --force"
    else
      command %(if [ ! -d "#{fetch(:deploy_to)}/scm/objects" ]; then
          echo "-----> Cloning the Git repository"
          #{echo_cmd %[git clone "#{fetch(:repository)}" "#{fetch(:deploy_to)}/scm" --bare]}
        else
          echo "-----> Fetching new git commits"
          #{echo_cmd %[(cd "#{fetch(:deploy_to)}/scm" && git fetch "#{fetch(:repository)}" "#{fetch(:branch)}:#{fetch(:branch)}" --force)]}
        fi &&
        echo "-----> Using git branch '#{fetch(:branch)}'" &&
        #{echo_cmd %[git clone "#{fetch(:deploy_to)}/scm" . --recursive --branch "#{fetch(:branch)}"]}), quiet: true
    end

    comment 'Using this git commit'
    command 'git rev-parse HEAD > .mina_git_revision'
    command "git --no-pager log --format='%aN (%h):%n> %s' -n 1"
    command 'rm -rf .git'
  end

  task revision: :environment do
    ensure!(:deploy_to)
    command "cat #{fetch(:current_path)}/.mina_git_revision"
  end
end
