namespace :git do
  desc "Clones the Git repository to the release path."
  task :clone do
    validate_set :repository
    settings.branch ||= 'master'

    queue %{
      echo "-----> Initializing path #{release_path}"
      mkdir -p "#{release_path}" &&
      git clone "#{repository}" "#{release_path}" -b #{branch} --recursive --depth 1 &&
      rm -rf "#{curent_path}.git"
    }
  end

  desc "Tags the current release version."
  task :tag_release do
    # TODO: This doesn't work right, you don't even know if the current working
    # directory has the version being deployed
    validate_set :current_version
    settings.release_tag ||= "release/#{current_version}"

    system "git tag #{release_tag} && git push --tags"
  end
end
