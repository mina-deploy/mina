module Mina
  # Helpers
  module Helpers

    # Invokes another Rake task.
    #
    # Invokes the task given in `task`. Returns nothing.
    #
    #     invoke :'git:clone'
    #     invoke :restart
    #
    def invoke(task)
      Rake.application.invoke_task task
    end

    # Evaluates an ERB block in the current scope and returns a string.
    #
    #     a = 1
    #     b = 2
    #
    #     # Assuming foo.erb is <%= a %> and <%= b %>
    #     puts erb('foo.erb')
    #
    #     #=> "1 and 2"
    #
    # Returns the output string of the ERB template.
    #
    def erb(file, b=binding)
      require 'erb'
      erb = ERB.new(File.read(file))
      erb.result b
    end

    # SSHs into the host and runs the code that has been queued.
    #
    # This is already automatically invoked before Rake exits to run all
    # commands that have been queued up.
    #
    #     queue "sudo restart"
    #     run!
    #
    # Returns nothing.
    #
    def run!
      report_time { ssh commands(:default) }
    end

    # Report time elapsed in the block.
    # Returns the output of the block.
    def report_time(&blk)
      time, output = measure &blk
      print_str "Elapsed time: %.2f seconds" % [time]
      output
    end

    # Measures the time (in ms) a block takes.
    # Returns a [time, output] tuple.
    def measure(&blk)
      t = Time.now
      output = yield
      [(Time.now - t).to_i, output]
    end

    # Executes a command via SSH.
    #
    # Returns nothing usually, but if `{ return: true }` is given, returns the
    # STDOUT output of the SSH session.
    #
    # options  - Hash of options.
    #            :pretty  - Prettify the output.
    #            :return  - If set to true, returns the output.
    #
    # Example
    #
    #     ssh("ls", return: true)
    #
    def ssh(cmd, options={})
      cmd = cmd.join("\n")  if cmd.is_a?(Array)

      require 'shellwords'

      result = 0
      script = Shellwords.escape("true;"+cmd)

      if options[:return] == true
        result = `#{ssh_command} -- bash -c #{script}`

      elsif simulate_mode?
        str = "Executing the following via '#{ssh_command}':"
        puts "#!/usr/bin/env bash"
        puts "# #{str}"
        puts "# " + ("-" * str.size)
        puts "#"

        puts cmd

      else
        code = "#{ssh_command} -- bash #{bash_options} -c #{script}"
        if settings.term_mode == :pretty
          result = pretty_system(code)
        elsif settings.term_mode == :exec
          exec code
        else
          system code
          result = $?
        end
      end

      die result if result > 0
      result
    end

    # Exits with a nice looking message.
    # Returns nothing.
    #
    #     die 2
    #     die 2, "Tests failed"
    #
    def die(code, msg=null)
      str = "Failed with status #{code}"
      str += " (#{msg})" if msg
      err = Failed.new(str)
      err.exitstatus = code
      raise err
    end

    # Returns the SSH command to be executed.
    #
    #     set :domain, 'foo.com'
    #     set :user, 'diggity'
    #
    #     puts ssh_command
    #     #=> 'ssh diggity@foo.com'
    #
    def ssh_command
      args = domain!
      args = "#{user}@#{args}" if user?
      args << " -i #{identity_file}" if identity_file?
      args << " -p #{port}" if port?
      args << " -t"
      "ssh #{args}"
    end

    # Queues code to be ran.
    #
    # This queues code to be ran to the current code bucket (defaults to `:default`).
    # To get the things that have been queued, use commands[:default]
    #
    # Returns nothing.
    #
    #     queue "sudo restart"
    #     queue "true"
    #
    #     commands == ['sudo restart', 'true']
    #
    def queue(code)
      commands
      commands(@to) << unindent(code)
    end

    # Internal: Normalizes indentation on a given string.
    #
    # Returns the normalized string without extraneous indentation.
    #
    #     puts unindent %{
    #       Hello
    #         There
    #     }
    #     # Output:
    #     # Hello
    #     #   There
    #
    def unindent(code)
      if code =~ /^\n([ \t]+)/
        code = code.gsub(/^#{$1}/, '')
      end

      code.strip
    end

    def reindent(n, code)
      indent n, unindent(code)
    end

    # Returns an array of queued code strings.
    #
    # You may give an optional `aspect`.
    #
    # Returns an array of strings.
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
    # Returns nothing.
    #
    #   queue "sudo restart"
    #   queue "true"
    #   commands.should == ['sudo restart', 'true']
    #
    #   isolate do
    #     queue "reload"
    #     commands.should == ['reload']
    #   end
    #
    #   commands.should == ['sudo restart', 'true']
    #
    def isolate(&blk)
      old, @commands = @commands, nil
      result = yield
      new_code, @commands = @commands, old
      result
    end

    # Starts a new block where #commands are collected, to be executed inside `path`.
    #
    # Returns nothing.
    #
    #   in_directory './webapp' do
    #     queue "./reload"
    #   end
    #
    #   commands.should == ['cd ./webapp && (./reload && true)']
    #
    def in_directory(path, &blk)
      isolated_commands = isolate { yield; commands }
      isolated_commands.each { |cmd| queue "(cd #{path} && (#{cmd}))" }
    end

    # Defines instructions on how to do a certain thing.
    # This makes the commands that are `queue`d go into a different bucket in commands.
    #
    # Returns nothing.
    #
    #     to :prepare do
    #       run "bundle install"
    #     end
    #     to :launch do
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
    # Sets given symbol `key` to value in `value`.
    #
    # Returns the value.
    #
    #     set :domain, 'kickflip.me'
    #
    def set(key, value)
      settings.send :"#{key}=", value
    end

    # Sets default settings.
    # Sets given symbol `key` to value in `value` only if the key isn't set yet.
    #
    # Returns the value.
    #
    #     set_default :term_mode, :pretty
    #     set :term_mode, :system
    #     settings.term_mode.should == :system
    #
    #     set :term_mode, :system
    #     set_default :term_mode, :pretty
    #     settings.term_mode.should == :system
    #
    def set_default(key, value)
      settings.send :"#{key}=", value  unless settings.send(:"#{key}?")
    end

    # Accesses the settings hash.
    #
    #     set :domain, 'kickflip.me'
    #     settings.domain  #=> 'kickflip.me'
    #     domain           #=> 'kickflip.me'
    #
    def settings
      @settings ||= Settings.new
    end

    # Hook to get settings.
    # See #settings for an explanation.
    #
    # Returns things.
    #
    def method_missing(meth, *args, &blk)
      settings.send meth, *args
    end

    def indent(count, str)
      str.gsub(/^/, " "*count)
    end

    def error(str)
      $stderr.write "#{str}\n"
    end

    # Converts a bash command to a command that echoes before execution.
    # Used to show commands in verbose mode. This does nothing unless verbose mode is on.
    #
    # Returns a string of the compound bash command, typically in the format of
    # `echo xx && xx`. However, if `verbose_mode?` is false, it returns the
    # input string unharmed.
    #
    #     echo_cmd("ln -nfs releases/2 current")
    #     #=> echo "$ ln -nfs releases/2 current" && ln -nfs releases/2 current
    #
    def echo_cmd(str)
      if verbose_mode?
        "echo #{("$ " + str).inspect} &&\n#{str}"
      else
        str
      end
    end

    # Internal: Invoked when Rake exits.
    #
    # Returns nothing.
    #
    def mina_cleanup!
      run! if commands.any?
    end

    # Checks if Rake was invoked with --verbose.
    #
    # Returns true or false.
    #
    def verbose_mode?
      if Rake.respond_to?(:verbose)
        # Rake 0.9.x
        Rake.verbose == true
      else
        # Rake 0.8.x
        RakeFileUtils.verbose_flag != :default
      end
    end

    # Checks if Rake was invoked with --simulate.
    #
    # Returns true or false.
    #
    def simulate_mode?
      !! ENV['simulate']
    end
  end
end
