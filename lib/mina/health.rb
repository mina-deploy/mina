desc "Try access the deployed domain for health check and undo last deploy if has a problem"
task :health do
  queue %[
        echo "-----> Health Checking... (http://#{domain})"
        curl -fs http://#{domain} > /dev/null
      ]
end
