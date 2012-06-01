namespace :bundle do
  desc "Install gem dependencies using Bundler."
  task :install do
    bundle_path = "#{release_path}/vendor/bundle"
    queue %{
      echo "-----> Installing gem dependencies using Bundler"
      mkdir -p "#{shared_path}/bundle"
      mkdir -p "#{release_path}/vendor"
      ln -s "#{shared_path}/bundle" "#{bundle_path}"
      (cd "#{bundle_path}"; ls -la)
      bundle install --without development:test --path "#{bundle_path}" --binstubs bin/ --deployment
    }
  end
end
