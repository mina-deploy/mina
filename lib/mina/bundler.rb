# # Modules: Bundler
# Adds settings and tasks for managing Ruby Bundler.
#
#     require 'mina/bundler'

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### bundle_bin
# Sets the bundle path.

set_default :bundle_bin, 'bundle'

# ### bundle_path
# Sets the path to where the gems are expected to be.
#
# This path will be symlinked to `./shared/bundle` so that the gems cache will
# be shared between all releases.

set_default :bundle_path, './vendor/bundle'

# ### bundle_withouts
# Sets the colon-separated list of groups to be skipped from installation.

set_default :bundle_withouts, 'development:test'

# ### bundle_options
# Sets the options for installing gems via Bundler.

set_default :bundle_options, lambda { %{--without #{bundle_withouts} --path "#{bundle_path}" --deployment} }

# ## Deploy tasks
# These tasks are meant to be invoked inside deploy scripts, not invoked on
# their own.

namespace :bundle do
  # ### bundle:install
  # Installs gems.
  desc "Install gem dependencies using Bundler."
  task :install do
    queue %{
      echo "-----> Installing gem dependencies using Bundler"
      #{echo_cmd %[mkdir -p "#{deploy_to}/#{shared_path}/bundle"]}
      #{echo_cmd %[mkdir -p "#{File.dirname bundle_path}"]}
      #{echo_cmd %[ln -s "#{deploy_to}/#{shared_path}/bundle" "#{bundle_path}"]}
      #{echo_cmd %[#{bundle_bin} install #{bundle_options}]}
    }
  end
end
