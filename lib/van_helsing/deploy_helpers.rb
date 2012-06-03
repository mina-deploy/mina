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
      # TODO: Deprecate these and generate them in the script.
      settings.build_id   = "%010i%04i" % [Time.now.to_i, rand(9999)]
      settings.build_path = lambda { "#{releases_path}/build-#{settings.build_id!}" }

      code = isolate do
        yield
        erb VanHelsing.root_path('data/deploy.sh.erb')
      end
    end
  end
end
