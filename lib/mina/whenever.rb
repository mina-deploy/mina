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

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### whenever_name
# Override the default name used by Whenever when clearing,
# updating or writing the crontab file.

namespace :whenever do
  # NOTE: setting this as a lambda to allow the user to override
  # the domain variable at any time in their schedule.rb file
  name = lambda { whenever_name || "#{domain}_#{rails_env}" }

  desc "Clear crontab"
  task :clear => :environment  do
    queue %{
      echo "-----> Clear crontab for #{name.call}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; #{bundle_bin} exec whenever --clear-crontab #{name.call} --set 'environment=#{rails_env}&path=#{deploy_to!}/#{current_path!}']}
    }
  end
  desc "Update crontab"
  task :update => :environment do
    queue %{
      echo "-----> Update crontab for #{name.call}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; #{bundle_bin} exec whenever --update-crontab #{name.call} --set 'environment=#{rails_env}&path=#{deploy_to!}/#{current_path!}']}
    }
  end
  desc "Write crontab"
  task :write => :environment do
    queue %{
      echo "-----> Update crontab for #{name.call}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; #{bundle_bin} exec whenever --write-crontab #{name.call} --set 'environment=#{rails_env}&path=#{deploy_to!}/#{current_path!}']}
    }
  end
end
