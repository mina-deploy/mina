namespace :git do
  desc "Clones the Git repository to the release path."
  task :clone do
    settings.revision ||= `git rev-parse HEAD`.strip

    queue %{
      echo "-----> Cloning the Git repository"
      #{echo_cmd %[git clone "#{repository!}" . -n --recursive]} &&
      echo "-----> Using revision #{revision}" &&
      #{echo_cmd %[git checkout "#{revision}" -b current_release 1>/dev/null]} &&
      #{echo_cmd %[rm -rf .git]}
    }
  end
end
