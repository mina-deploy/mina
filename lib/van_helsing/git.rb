namespace :git do
  desc "Clones the Git repository to the release path."
  task :clone do
    settings.revision ||= `git rev-parse HEAD`.strip

    queue %{
      echo "-----> Cloning from the Git repository"
      git clone "#{settings.repository!}" . -n --recursive &&
      git checkout "#{revision}" 2>/dev/null &&
      rm -rf .git
    }
  end
end
