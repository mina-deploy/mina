module VanHelsing
  module Helpers
    # Invokes another Rake task.
    def invoke(task)
      Rake.application.invoke_task task
    end

    # Wraps the things inside it in a deploy script.
    #
    #     deploy do
    #       invoke :'git:checkout'
    #     end
    #
    def deploy(&blk)
      settings.build_id   = "%010i%04i" % [Time.now.to_i, rand(9999)]
      settings.build_path = lambda { "#{releases_path}/build-#{settings.build_id!}" }

      code = isolate do
        yield
        erb VanHelsing.root_path('data/deploy.sh.erb')
      end

      queue code
    end

    # Evaluates an ERB block and returns a string.
    def erb(file, b=binding)
      require 'erb'
      erb = ERB.new(File.read(file))
      erb.result b
    end

    # SSHs into the host and runs the code that has been queued.
    # This is ran before Rake exits to run all commands that have been
    # queued up.
    #
    #     queue "sudo restart"
    #     run!
    #
    def run!
      ssh commands(:default), pretty: true
    end

    # Executes a command via SSH.
    #
    # Options:
    #
    #     pretty:    Prettify the output.
    #
    def ssh(cmd, options={})
      cmd = cmd.join("\n")  if cmd.is_a?(Array)

      args = host!
      args = "#{user}@#{args}" if user?
      args << " -i #{identity_file}" if identity_file?

      code = [
        '( cat <<VH_EOF',
        indent(2, unindent(cmd.gsub(/\$/,'\$').gsub(/`/, '\\\\'+'`'))),
        "VH_EOF",
        ") | ssh #{args} -- bash -"
      ].join("\n")

      result = 0
      if ENV['simulate']
        puts code
      elsif options[:pretty]
        result = pretty_system(code)
      else
        system(code)
        result = $?
      end

      unless result == 0
        raise Failed.new(message: "Failed with status #{result}", exitstatus: result)
      end

      result
    end

    # Works like 'system', but indents
    # Returns the exit code in integer form.
    def pretty_system(code)
      require 'open3'
      Open3.popen3('bash', '-') do |i, o, e, t|
        i.write "( #{code} ) 2>&1\n"
        i.close

        last = nil
        while c = o.getc
          break if o.closed?
          if last == "\n"
            if c == "-" && ((c += o.read(5)) == "----->")
              print c
            else
              print " "*7 + c
            end
          else
            print c
          end

          last = c
        end

        # t.value is Process::Status
        t.value.exitstatus
      end
    end

    # Queues code to be ran.
    # This queues code to be ran to the current code bucket (defaults to `:default`).
    # To get the things that have been queued, use commands[:default]
    #
    #     queue "sudo restart"
    #     queue "true"
    #     commands(:default).should == ['sudo restart', 'true']
    #
    def queue(code)
      commands
      commands(@to) << unindent(code)
    end

    def unindent(code)
      if code =~ /^\n([ \t]+)/
        code = code.gsub(/^#{$1}/, '')
      end

      code.strip
    end

    # Returns a hash of the code blocks where commands have been queued.
    #
    #     queue "sudo restart"
    #     queue "true"
    #
    #     to :clean do
    #       queue "rm"
    #     end
    #
    #     commands == ["sudo restart", "true"]
    #     commands(:clean) == ["rm"]
    #
    def commands(aspect=:default)
      (@commands ||= begin
        @to = :default
        Hash.new { |h, k| h[k] = Array.new }
      end)[aspect]
    end

    # Starts a new block where new #commands are collected.
    #
    #     queue "sudo restart"
    #     queue "true"
    #     commands.should == ['sudo restart', 'true']
    #
    #     isolate do
    #       queue "reload"
    #       commands.should == ['reload']
    #     end
    #
    #     commands.should == ['sudo restart', 'true']
    #
    def isolate(&blk)
      old, @commands = @commands, nil
      result = yield
      new_code, @commands = @commands, old
      result
    end

    # Defines instructions on how to do a certain thing.
    # This makes the commands that are `queue`d go into a different bucket in commands.
    #
    #     to :prepare do
    #       run "bundle install"
    #     end
    #     to :restart do
    #       run "nginx -s restart"
    #     end
    #
    #     commands(:prepare) == ["bundle install"]
    #     commands(:restart) == ["nginx -s restart"]
    #
    def to(name, &blk)
      old, @to = @to, name
      result = yield
      @to = old
      result
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
      @settings ||= Settings.new
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

    def echo_cmd(str)
      "echo #{("$ " + str).inspect} &&\n#{str}"
    end

    def vh_cleanup!
      run! if commands.any?
    end
  end
end
