settings.branch ||= "master"

namespace :git do
  desc "Clones the Git repository to the release path."
  task :clone do
    if revision?
      error "The Git option `:revision` has now been deprecated."
      error "Please use `:commit` or `:branch` instead."
      exit
    end

    init = %[
      if [ ! -d "#{deploy_to}/scm/objects" ]; then
        echo "-----> Cloning the Git repository"
        #{echo_cmd %[git clone "#{repository!}" "#{deploy_to}/scm" --bare]}
    ]

    clone = if commit?
      %[
        else
          echo "-----> Fetching new git commits"
          #{echo_cmd %[(cd "#{deploy_to}/scm" && git fetch "#{repository!}")]}
        fi &&
        echo "-----> Using git commit '#{commit}'" &&
        #{echo_cmd %[git clone "#{deploy_to}/scm" . --recursive]} &&
        #{echo_cmd %[git checkout -b current_release "#{commit}" --force]} &&
      ]
    else
      %{
        else
          echo "-----> Fetching new git commits"
          #{echo_cmd %[(cd "#{deploy_to}/scm" && git fetch "#{repository!}" "#{branch}:#{branch}" --force)]}
        fi &&
        echo "-----> Using git branch '#{branch}'" &&
        #{echo_cmd %[git clone "#{deploy_to}/scm" . --depth 1 --recursive --branch "#{branch}"]} &&
      }
    end

    status = %[
      echo "-----> Using this git commit" &&
      echo &&
      #{echo_cmd %[git log --format="%aN (%h):%n> %s" -n 1]} &&
      #{echo_cmd %[rm -rf .git]} &&
      echo
    ]

    queue init + clone + status
  end
end
