namespace :git do
  desc "Clones the Git repository to the release path."
  task :clone do
    settings.revision ||= `git rev-parse HEAD`.strip

    queue %{
      echo "-----> Cloning the Git repository"
      #{echo_cmd %[git clone "%s" . -n --recursive] % [settings.repository!]} &&
      echo "-----> Using revision #{revision}" &&
      #{echo_cmd %[git checkout "%s" -b current_release 1>/dev/null] % [revision]} &&
      #{echo_cmd %[rm -rf .git]}
    }
  end
end
