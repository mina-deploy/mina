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

    def version which = :current
      version = File.open(settings.deploy_to + '/last_version', 'r').read.to_i
      version += 1 if which == :next
      version
    end
  end
end
