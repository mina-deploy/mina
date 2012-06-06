module VanHelsing
  module DeployHelpers
    # Wraps the things inside it in a deploy script, and queues it.
    # This generates a script using deploy_script and queues it.
    def deploy(&blk)
      queue deploy_script(&blk)
    end

    # Wraps the things inside it in a deploy script.
    #
    #     script = deploy_script do
    #       invoke :'git:checkout'
    #     end
    #
    #     queue script
    #
    def deploy_script(&blk)
      set :term_mode, :pretty  unless settings.term_mode?
      code = isolate do
        yield
        erb VanHelsing.root_path('data/deploy.sh.erb')
      end
    end
  end
end
