namespace :bundle do
  desc "Install gem dependencies using Bundler."
  task :install do
    queue %{
      echo "-----> Installing gem dependencies using Bundler"
      bundle install --without development:test --path vendor/bundle --binstubs bin/ --deployment
    }
  end
end
