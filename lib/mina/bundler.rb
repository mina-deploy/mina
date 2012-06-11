
settings.bundle_bin ||= 'bundle'
settings.bundle_path ||= './vendor/bundle'
settings.bundle_options ||= lambda { %{--without development:test --path "#{bundle_path}" --binstubs bin/ --deployment} }

namespace :bundle do
  desc "Install gem dependencies using Bundler."
  task :install do
    if bundle_path.nil?
      queue %{
        echo "-----> Installing gem dependencies using Bundler"
        #{echo_cmd %[#{bundle_bin} install #{bundle_options}]}
      }
    else
      queue %{
        echo "-----> Installing gem dependencies using Bundler"
        #{echo_cmd %[mkdir -p "#{deploy_to}/#{shared_path}/bundle"]}
        #{echo_cmd %[mkdir -p "#{File.dirname bundle_path}"]}
        #{echo_cmd %[ln -s "#{deploy_to}/#{shared_path}/bundle" "#{bundle_path}"]}
        #{echo_cmd %[#{bundle_bin} install #{bundle_options}]}
      }
    end
  end
end