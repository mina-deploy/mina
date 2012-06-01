module VanHelsing
  module Helpers
    # Invokes another Rake task.
    def invoke(task)
      Rake::Task[task.to_sym].invoke
    end

    # Wraps the things inside it in a deploy script.
    #
    #     deploy! do
    #       invoke :'git:checkout'
    #     end
    #
    def deploy(&blk)
      validate_set :deploy_to

      settings.current_version ||= Time.now.strftime("%Y-%m-%d--%H-%m-%S")
      settings.release_path    ||= "#{deploy_to}/releases/#{current_version}"
      settings.shared_path     ||= "#{deploy_to}/shared"
      settings.current_path    ||= "#{deploy_to}/current"
      settings.lock_file       ||= "#{deploy_to}/deploy.lock"

      code = ''

      isolate do
        yield
        prepare = codes[:default].map { |s| "(\n#{indent 2, s}\n)" }.join(" && ")
        restart = codes[:restart].map { |s| "(\n#{indent 2, s}\n)" }.join(" && ")
        clean   = codes[:clean].map   { |s| "(\n#{indent 2, s}\n)" }.join(" && ")

        require 'erb'
        erb = ERB.new(File.read(VanHelsing.root_path('data/deploy.sh.erb')))
        code = erb.result(binding)
      end
      
      queue code
    end

    # Deploys and runs immediately.
    def deploy!(&blk)
      deploy &blk
      run!
    end

    # SSHs into the host and runs the code that has been queued.
    #
    #     queue "sudo restart"
    #     run!
    #
    def run!
      validate_set :host

      args = settings.host
      args = "#{settings.user}@#{args}" if settings.user
      args << " -i #{settings.identity_file}" if settings.identity_file

      code = [
        '( cat <<DEPLOY_EOF',
        indent(2, codes[:default].join("\n").gsub('$', '\$').strip),
        "DEPLOY_EOF",
        ") | ssh #{args} -- bash -"
      ].join("\n")

      puts code
    end

    # Queues code to be ran.
    # To get the things that have been queued, use codes[:default]
    def queue(code)
      codes
      codes[@code_block] << code.gsub(/^ */, '')
    end

    # Returns a hash of the code blocks where commands have been queued.
    #
    #     > codes
    #     #=> { :default => [ 'echo', 'sudo restart', ... ] }
    #
    def codes
      @codes ||= begin
        @code_block = :default
        Hash.new { |h, k| h[k] = Array.new }
      end
    end

    # Starts a new block where new #codes are collected.
    #
    #     queue "sudo restart"
    #     codes[:default].should == ['sudo restart']
    #
    #     isolate do
    #       queue "reload"
    #       codes[:default].should == ['reload']
    #     end
    #
    #     codes[:default].should == ['sudo restart']
    #
    def isolate(&blk)
      old, @codes = @codes, nil
      yield
      new_code, @codes = @codes, old
      codes
    end

    # Defines instructions on how to do a certain thing.
    # This makes the codes that are `queue`d go into a different bucket in codes.
    #
    #     to :prepare do
    #       run "bundle install"
    #     end
    #     to :restart do
    #       run "nginx -s restart"
    #     end
    #
    #     codes[:prepare] == ["bundle install"]
    #     codes[:restart] == ["nginx -s restart"]
    #
    def to(name, &blk)
      old, @code_block = @code_block, name
      yield
      @code_block = old
    end

    # Sets settings.
    #
    #     set :host, 'kickflip.me'
    #
    def set(key, value)
      settings.send :"#{key}=", value
    end

    # Accesses the settings hash.
    #
    #     set :host, 'kickflip.me'
    #     settings.host  #=> 'kickflip.me'
    #     host           #=> 'kickflip.me'
    #
    def settings
      @settings ||= OpenStruct.new
    end

    # Hook to get settings.
    # See #settings for an explanation.
    def method_missing(meth, *args, &blk)
      @settings.send meth, *args
    end

    def indent(count, str)
      str.gsub(/^/, " "*count)
    end

    def error(str)
      $stderr.write "#{str}\n"
    end

    # Throws an error if a certain setting is not set.
    #
    #     validate_set :host
    #     validate_set :deploy_to, :repository
    #
    def validate_set(*settings)
      settings.each do |key|
        unless @settings.send(key)
          error "ERROR: You must set the :#{key} setting."
          exit 1
        end
      end
    end
  end
end
