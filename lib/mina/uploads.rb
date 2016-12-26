settings.uploads_path ||= './public/uploads'

namespace :uploads do
  desc 'Link uploaded files directory across releases'
  task :link do
    queue %{
      echo "-----> Linking uploaded files directory"
      #{echo_cmd %[mkdir -p "#{deploy_to}/#{shared_path}/uploads"]}
      #{echo_cmd %[mkdir -p "#{File.dirname uploads_path}"]}
      #{echo_cmd %[ln -s "#{deploy_to}/#{shared_path}/uploads" "#{uploads_path}"]}
    }
  end
end
