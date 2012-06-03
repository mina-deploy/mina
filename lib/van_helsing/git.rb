namespace :git do
  desc "Clones the Git repository to the release path."
  task :clone do
    settings.revision ||= `git rev-parse HEAD`.strip

    queue %{
      echo "-----> Cloning the Git repository"
      git clone "#{settings.repository!}" . -n --recursive &&
      echo "-----> Using revision #{revision}" &&
      git checkout "#{revision}" -b current_release >/dev/null &&
      rm -rf .git
    }
  end
end
