namespace :vh do
  desc "Updates the current_path symlink."
  task :update_symlinks do
    queue %{
      echo "-----> Updating the current path"
      rm -f "#{current_path}"
      ln -s "#{release_path}" "#{current_path}"
    }
  end
end
