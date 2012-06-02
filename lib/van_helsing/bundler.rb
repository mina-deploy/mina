
settings.bundle_path ||= './vendor/bundle'
settings.bundle_options ||= %{--without development:test --path "#{bundle_path}" --binstubs bin/ --deployment"}

namespace :bundle do
  desc "Install gem dependencies using Bundler."
  task :install do
    bundle_path = "./vendor/bundle"
    queue %{
      echo "-----> Installing gem dependencies using Bundler"
      mkdir -p "#{shared_path}/bundle"
      mkdir -p "#{release_path}/vendor"
      ln -s "#{shared_path}/bundle" "#{bundle_path}"
      bundle install #{bundle_options}
    }
  end
end
