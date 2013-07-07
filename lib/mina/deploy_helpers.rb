# # Helpers: Deploy helpers
# Helpers for deployment.
module Mina
  module DeployHelpers
    # ### deploy
    # Wraps the things inside it in a deploy script and queues it.
    # This generates a script using deploy_script and queues it.
    #
    # Returns nothing.
    #
    def deploy(&blk)
      queue deploy_script(&blk)
    end

    # ### deploy_script
    # Wraps the things inside it in a deploy script.
    #
    #   script = deploy_script do
    #     invoke :'git:checkout'
    #   end
    #
    #   queue script
    #
    # Returns the deploy script as a string, ready for `queue`ing.
    #
    def deploy_script(&blk)
      set_default :term_mode, :pretty
      code = isolate do
        yield
        erb Mina.root_path('data/deploy.sh.erb')
      end
    end

    # Function to retrieve the version number within the deploy script
    # which parameter specifies if the user wants the current version or the
    # next version
    #
    # returns the requested version
    #
    def version which
      set_default :version_scheme, :sequence

      version = File.open(settings.deploy_to + '/last_version', 'r').read if File.exists?(settings.deploy_to + '/last_version')
            
      return version if version and which == :current

      case settings.version_scheme
      when :sequence
        return version.to_i.next if version
        1
      when :date
        @@date_time ||= Time.now.utc
        "%04d%02d%02d%02d%02d%02d" % [@@date_time.year, @@date_time.month, @@date_time.day,
                                      @@date_time.hour, @@date_time.min, @@date_time.sec]
      end
    end
  end
end
