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
    #     script = deploy_script do
    #       invoke :'git:checkout'
    #     end
    #
    #     queue script
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
  end
end
