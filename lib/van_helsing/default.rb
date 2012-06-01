task :force_unlock do
  queue %{echo "-----> Unlocking"}
  queue %{rm -f "#{deploy_to}/deploy.lock"}
  queue %{exit 234}
  run!
end
