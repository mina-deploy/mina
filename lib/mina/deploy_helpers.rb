module Mina
  # Helpers for deployment
  module DeployHelpers
    #  Wraps the things inside it in a deploy script and queues it.
    # This generates a script using deploy_script and queues it.
    #
    # Returns nothing.
    #
    def deploy(&blk)
      queue deploy_script(&blk)
    end

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
      version = File.open(settings.deploy_to + '/last_version', 'r').read.to_i

      return version if which == :current

      case settings.version_scheme
      when :sequence
        return version.next
      when :date
        time = Time.now
        return "%04d%02d%02d" % [time.year, time.month, time.day]
      end      
    end
  end
end
