namespace :git do
  desc "Clones the Git repository to the release path."
  task :clone do
    validate_set :repository
    settings.revision ||= `git rev-parse HEAD`.strip

    queue %{
      echo "-----> Initializing path #{release_path}"
      mkdir -p "#{release_path}" &&
      git clone "#{repository}" "#{release_path}" -n --recursive &&
      git checkout "#{revision}" &&
      rm -rf "#{curent_path}.git"
    }
  end

  desc "Tags the current release version. (Done after deployment)"
  task :tag_release do
    # TODO: This doesn't work right, you don't even know if the current working
    # directory has the version being deployed
    validate_set :current_version
    settings.release_tag ||= "release/#{current_version}"

    system "git tag #{release_tag} #{revision} && git push --tags"
  end
end
