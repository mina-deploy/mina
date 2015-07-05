# # Helpers

module Mina
  module Helpers

    # ### invoke
    # Invokes another Rake task.
    # By default if the task has already been invoked it will not been executed again (see the `:reenable` option).
    #
    # Invokes the task given in `task`. Returns nothing.
    #
    #     invoke :'git:clone'
    #     invoke :restart
    #
    # Options:
    #   reenable (bool) - Execute the task even next time.
    #

    def invoke(task, options = {})
      # task.to_s is a ruby 1.8.7 fix
      task = task.to_s
      Rake.application.invoke_task task
      if options[:reenable]
        name = Rake.application.parse_task_string(task).first
        Rake::Task[name].reenable
      end
    end

    # ### erb
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

    def erb(file, b=binding)
      require 'erb'
      erb = ERB.new(File.read(file))
      erb.result b
    end

    # ### run!
    # SSHs into the host and runs the code that has been queued.
    #
    # This is already automatically invoked before Rake exits to run all
    # commands that have been queued up.
    #
    #     queue "sudo restart"
    #     run!
    #
    # Returns nothing.

    def run!
      report_time { ssh commands(:default) }
    end

    # ### run_local!
    # runs the code locally that has been queued.
    # Has to be in :before_hook or :after_hook queue
    #
    # This is already automatically invoked before Rake exits to run all
    # commands that have been queued up.
    #
    #     to :before_hook do
    #       queue "cp file1 file2"
    #     end
    #     run_local!(:before_hook)
    #
    # Returns nothing.
    def run_local!(aspect)
      report_time { local commands(aspect) }
    end

    # ### report_time
    # Report time elapsed in the block.
    # Returns the output of the block.
    #
    #     report_time do
    #       sleep 2
    #       # do other things
    #     end
    #
    #     # Output:
    #     # Elapsed time: 2.00 seconds

    def report_time(&blk)
      time, output = measure &blk
      print_str "Elapsed time: %.2f seconds" % [time]
      output
    end

    # ### measure
    # Measures the time (in seconds) a block takes.
    # Returns a [time, output] tuple.

    def measure(&blk)
      t = Time.now
      output = yield
      [Time.now - t, output]
    end

    # ### mina_cleanup
    # __Internal:__ Invoked when Rake exits.
    #
    # Returns nothing.

    def mina_cleanup!
      run_local!(:before_hook) if commands(:before_hook).any?
      run! if commands.any?
      run_local!(:after_hook) if commands(:after_hook).any?
    end

    # ## Errors

    # ### die
    # Exits with a nice looking message.
    # Returns nothing.
    #
    #     die 2
    #     die 2, "Tests failed"

    def die(msg=nil, code=1)
      str = "Failed with status #{code}"
      str += " (#{msg})" if msg
      err = Failed.new(str)
      err.exitstatus = code
      raise err
    end

    # ### error
    # __Internal:__ Prints to stdout.
    # Consider using `print_error` instead.

    def error(str)
      $stderr.write "#{str}\n"
    end

    # ## Queueing

    # ### queue
    # Queues code to be run.
    #
    # This queues code to be run to the current code bucket (defaults to `:default`).
    # To get the things that have been queued, use commands[:default]
    #
    # Returns nothing.
    #
    #     queue "sudo restart"
    #     queue "true"
    #
    #     commands == ['sudo restart', 'true']

    def queue(code)
      commands
      @to ||= :default
      commands(@to) << unindent(code)
    end

    # ### queue!
    # Shortcut for `queue`ing a command that shows up in verbose mode.

    def queue!(code)
      queue echo_cmd(code)
    end

    # ### echo_cmd
    # Converts a bash command to a command that echoes before execution.
    # Used to show commands in verbose mode. This does nothing unless verbose mode is on.
    #
    # Returns a string of the compound bash command, typically in the format of
    # `echo xx && xx`. However, if `verbose_mode?` is false, it returns the
    # input string unharmed.
    #
    #     echo_cmd("ln -nfs releases/2 current")
    #     #=> echo "$ ln -nfs releases/2 current" && ln -nfs releases/2 current

    def echo_cmd(str)
      if verbose_mode?
        require 'shellwords'
        "echo #{Shellwords.escape("$ " + str)} &&\n#{str}"
      else
        str
      end
    end

    # ## Commands

    # ### commands
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

    def commands(aspect = :default)
      (@commands ||= begin
        Hash.new { |h, k| h[k] = Array.new }
      end)[aspect]
    end

    # ### isolate
    # Starts a new block where new `commands` are collected.
    #
    # Returns nothing.
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

    def isolate(&blk)
      old, @commands = @commands, nil
      result = yield
      new_code, @commands = @commands, old
      result
    end

    # ### in_directory
    # Starts a new block where #commands are collected, to be executed inside `path`.
    #
    # Returns nothing.
    #
    #     in_directory './webapp' do
    #       queue "./reload"
    #     end
    #
    #     commands.should == ['cd ./webapp && (./reload && true)']

    def in_directory(path, &blk)
      isolated_commands = isolate { yield; commands }
      isolated_commands.each { |cmd| queue "(cd #{path} && (#{cmd}))" }
    end

    # ### to
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

    def to(name, &blk)
      old, @to = @to, name
      yield
    ensure
      @to = old
    end

    # ## Settings helpers

    # ### set
    # Sets settings.
    # Sets given symbol `key` to value in `value`.
    #
    # Returns the value.
    #
    #     set :domain, 'kickflip.me'

    def set(key, value)
      settings.send :"#{key}=", value
    end

    # ### set_default
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

    def set_default(key, value)
      settings.send :"#{key}=", value  unless settings.send(:"#{key}?")
    end

    # ### settings
    # Accesses the settings hash.
    #
    #     set :domain, 'kickflip.me'
    #
    #     settings.domain  #=> 'kickflip.me'
    #     domain           #=> 'kickflip.me'

    def settings
      @settings ||= Settings.new
    end

    # ### method_missing
    # Hook to get settings.
    # See #settings for an explanation.
    #
    # Returns things.

    def method_missing(meth, *args, &blk)
      settings.send meth, *args
    end

    # ## Command line mode helpers

    # ### verbose_mode?
    # Checks if Rake was invoked with --verbose.
    #
    # Returns true or false.
    #
    #     if verbose_mode?
    #       queue %[echo "-----> Starting a new process"]
    #     end

    def verbose_mode?
      if Rake.respond_to?(:verbose)
        #- Rake 0.9.x
        Rake.verbose == true
      else
        #- Rake 0.8.x
        RakeFileUtils.verbose_flag != :default
      end
    end

    # ### simulate_mode?
    # Checks if Rake was invoked with --simulate.
    #
    # Returns true or false.

    def simulate_mode?
      !! ENV['simulate']
    end

    # ## Internal helpers

    # ### indent
    # Indents a given code block with `count` spaces before it.

    def indent(count, str)
      str.gsub(/^/, " "*count)
    end

    # ### unindent
    # __Internal:__ Normalizes indentation on a given string.
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

    def unindent(code)
      if code =~ /^\n([ \t]+)/
        code = code.gsub(/^#{$1}/, '')
      end

      code.strip
    end

    # ### reindent
    # Resets the indentation on a given code block.

    def reindent(n, code)
      indent n, unindent(code)
    end

    # ### capture
    # Returns the output of command via SSH.

    def capture(cmd, options={})
      ssh cmd, options.merge(:return => true)
    end

  end
end
