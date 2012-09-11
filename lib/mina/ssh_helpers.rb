# # Helpers: SSH helpers
# You don't need to invoke these helpers, they're already invoked automatically.
#
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

      cmd = cmd.join("\n")  if cmd.is_a?(Array)
      script = Shellwords.escape(cmd)

      if options[:return] == true
        `#{ssh_command} -- #{script}`

      elsif simulate_mode?
        ssh_simulate cmd

      else
        ensure_successful ssh_invoke(script, settings.term_mode)
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
      args = domain!
      args = "#{user}@#{args}" if user?
      args << " -i #{identity_file}" if identity_file?
      args << " -p #{port}" if port?
      args << " -A" if forward_agent?
      args << " #{ssh_options}"  if ssh_options?
      args << " -t"
      "ssh #{args}"
    end

  private

    # ## Private methods
    # `ssh` delegates to these.

    # ### ssh_simulate
    # __Internal:__ Prints SSH command. Called by `ssh`.

    def ssh_simulate(cmd)
      str = "Executing the following via '#{ssh_command}':"
      puts "#!/usr/bin/env bash"
      puts "# #{str}"
      puts "#"

      puts cmd

      0
    end

    # ### ssh_invoke
    # __Internal:__ Initiates an SSH session with script `script` with given
    # `term_mode`.  Called by `ssh`.

    def ssh_invoke(script, term_mode)
      term_mode = :"#{term_mode}"
      code = "#{ssh_command} -- #{script}"

      case term_mode
      when :pretty
        pretty_system(code)
      when :exec
        exec code
      else
        system code
        $?.to_i
      end
    end

    # ### ensure_successful
    # __Internal:__ Halts the execution if the given result code is not
    # successful (non-zero).

    def ensure_successful(result)
      die result if result.is_a?(Fixnum) && result > 0
      result
    end

  end
end
