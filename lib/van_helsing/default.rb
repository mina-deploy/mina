task :force_unlock do
  queue %{echo "-----> Unlocking"}
  queue %{rm -f "#{deploy_to}/deploy.lock"}
  run!
end
