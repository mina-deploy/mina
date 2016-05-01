# encoding: utf-8

# # Modules: Git
# Adds settings and tasks related to managing Git.
#
#     require 'mina/git'

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### branch
# Sets the branch to be deployed.

set_default :branch, 'master'

namespace :git do
  # ## Deploy tasks
  # These tasks are meant to be invoked inside deploy scripts, not invoked on
  # their own.

  # ### git:clone
  # Clones the Git repository. Meant to be used inside a deploy script.

  desc "Clones the Git repository to the release path."
  task :clone do
    if revision?
      error "The Git option `:revision` has now been deprecated."
      error "Please use `:commit` or `:branch` instead."
      exit
    end

    clone = if commit?
      %[
        echo "-----> Using git commit '#{commit}'" &&
        #{echo_cmd %[git clone "#{repository!}" . --recursive]} &&
        #{echo_cmd %[git checkout -b current_release "#{commit}" --force]} &&
      ]
    else
      %{
        if [ ! -d "#{deploy_to}/scm/objects" ]; then
          echo "-----> Cloning the Git repository"
          #{echo_cmd %[git clone "#{repository!}" "#{deploy_to}/scm" --bare]}
        else
          echo "-----> Fetching new git commits"
          #{echo_cmd %[(cd "#{deploy_to}/scm" && git fetch "#{repository!}" "#{branch}:#{branch}" --force)]}
        fi &&
        echo "-----> Using git branch '#{branch}'" &&
        #{echo_cmd %[git clone "#{deploy_to}/scm" . --recursive --branch "#{branch}"]} &&
      }
    end

    status = %[
      echo "-----> Using this git commit" &&
      echo &&
      #{echo_cmd %[git rev-parse HEAD > .mina_git_revision]} &&
      #{echo_cmd %[git --no-pager log --format='%aN (%h):%n> %s' -n 1]} &&
      #{echo_cmd %[rm -rf .git]} &&
      echo
    ]

    queue clone + status
  end

  # ### git:revision
  # Gets the current git revision deployed on server.
  task :revision do
    queue %[cat #{deploy_to}/current/.mina_git_revision]
  end
end
