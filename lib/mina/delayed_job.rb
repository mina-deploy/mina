# # Modules: delayed_job
# Adds settings and tasks for background processing
# with [delayed_job].
# [delayed_job]: https://rubygems.org/gems/delayed_job

set_default :delayed_job_executable, "bin/delayed_job"

namespace :delayed_job do
  desc "Restart delayed_job"
  task :restart do
    queue %{
      echo "-----> Restart delayed_job for #{domain}_#{rails_env}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; mkdir -p tmp/pids ; #{bundle_prefix} #{delayed_job_executable} restart]}
    }
  end
end
