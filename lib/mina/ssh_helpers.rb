# # Helpers: SSH helpers
# You don't need to invoke these helpers, they're already invoked automatically.

module Mina
  module SshHelpers

    # ### ssh
    # Executes a command via SSH.
    #
    # Returns nothing usually, but if `{ return: true }` is given, returns the
    # STDOUT output of the SSH session.
    #
    # `options` is a hash of options:
    #
    #  - `:pretty` - Prettify the output if true.
    #  - `:return`  - If set to true, returns the output.
    #
    # Example
    #
    #     ssh("ls", return: true)

    def ssh(cmd, options={})
      require 'shellwords'

      cmd.unshift("export #{env_vars}") if env_vars?
      cmd = cmd.join("\n")  if cmd.is_a?(Array)
      script = Shellwords.escape(cmd)

      if options[:return] == true
        `#{ssh_command} -- #{script}`

      elsif simulate_mode?
        Ssh.simulate(cmd, ssh_command)

      else
        result = Ssh.invoke(script, self)
        Ssh.ensure_successful result, self
      end
    end

    # ### ssh_command
    # Returns the SSH command to be executed.
    #
    #     set :domain, 'foo.com'
    #     set :user, 'diggity'
    #
    #     puts ssh_command
    #     #=> 'ssh diggity@foo.com'

    def ssh_command
      args = domain!.dup
      args = "#{user}@#{args}" if user?
      args << " -i #{identity_file}" if identity_file?
      args << " -p #{port}" if port?
      args << " -A" if forward_agent?
      args << " #{ssh_options}" if ssh_options?
      args << " -o StrictHostKeyChecking=no"
      args << " -t"
      "ssh #{args}"
    end

    # ## Private methods
    # `ssh` delegates to these.

    module Ssh

      extend self

      # ### Ssh.simulate
      # __Internal:__ Prints SSH command. Called by `ssh`.

      def simulate(cmd, ssh_command)
        str = "Executing the following via '#{ssh_command}':"
        puts "#!/usr/bin/env bash"
        puts "# #{str}"
        puts "#"

        puts cmd

        0
      end

      # ### Ssh.invoke
      # __Internal:__ Initiates an SSH session with script `script` with given
      # `term_mode`.  Called by `ssh`.

      def invoke(script, this)
        # Ruby 1.8.7 doesn't let you have empty symbols
        term_mode = :"#{this.settings.term_mode}" if this.settings.term_mode
        code = "#{this.ssh_command} -- #{script}"

        # Certain environments can't do :pretty mode.
        term_mode = :exec  if term_mode == :pretty && !pretty_supported?

        case term_mode
        when :pretty
          this.pretty_system(code)
        when :exec
          exec code
        else
          system code
          $?.to_i
        end
      end

      def pretty_supported?
        # open4 is not supported under Windows.
        # https://github.com/nadarei/mina/issues/58
        require 'rbconfig'
        ! (RbConfig::CONFIG['host_os'] =~ /mswin|mingw/)
      end

      # ### Ssh.ensure_successful
      # __Internal:__ Halts the execution if the given result code is not
      # successful (non-zero).

      def ensure_successful(result, this)
        this.die result if result.is_a?(Fixnum) && result > 0
        result
      end

    end

  end
end
