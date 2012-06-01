namespace :bundle do
  task :install do
    queue %{
      echo "-----> Installing dependencies using Bundler"
      bundle install --without development:test --path vendor/bundle --binstubs bin/ --deployment
    }
  end
end
