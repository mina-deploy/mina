namespace :git do
  desc "Clones the Git repository to the release path."
  task :clone do
    settings.revision ||= `git rev-parse HEAD`.strip

    queue %{
      echo "-----> Cloning from the Git repository
      git clone "#{settings.repository!}" . -n --recursive &&
      git checkout "#{revision}" 2>/dev/null &&
      rm -rf .git
    }
  end

  desc "Tags the current release version. (Done after deployment)"
  task :tag_release do
    # TODO: This doesn't work right, you don't even know if the current working
    # directory has the version being deployed
    settings.release_tag ||= "release/#{settings.current_version!}"

    system "git tag #{release_tag} #{revision} && git push --tags"
  end
end
