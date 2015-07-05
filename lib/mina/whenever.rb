# # Modules: Whenever
# Adds settings and tasks for managing projects with [whenever].
#
# [whenever]: http://rubygems.org/gems/whenever
#
#
# ## Common usage
#     require 'mina/whenever'
#
#     task :deploy => :environment do
#       deploy do
#         ...
#       to :launch do
#         invoke :'whenever:update'
#       end
#     end

namespace :whenever do
  desc "Clear crontab"
  task :clear => :environment  do
    queue %{
      echo "-----> Clear crontab for #{domain}_#{rails_env}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; #{bundle_bin} exec whenever --clear-crontab #{domain}_#{rails_env} --set 'environment=#{rails_env}&path=#{deploy_to!}/#{current_path!}']}
    }
  end
  desc "Update crontab"
  task :update => :environment do
    queue %{
      echo "-----> Update crontab for #{domain}_#{rails_env}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; #{bundle_bin} exec whenever --update-crontab #{domain}_#{rails_env} --set 'environment=#{rails_env}&path=#{deploy_to!}/#{current_path!}']}
    }
  end
  desc "Write crontab"
  task :write => :environment do
    queue %{
      echo "-----> Update crontab for #{domain}_#{rails_env}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; #{bundle_bin} exec whenever --write-crontab #{domain}_#{rails_env} --set 'environment=#{rails_env}&path=#{deploy_to!}/#{current_path!}']}
    }
  end
end
