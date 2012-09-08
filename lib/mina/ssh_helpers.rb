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
      cmd = cmd.join("\n")  if cmd.is_a?(Array)

      require 'shellwords'

      result = 0
      script = Shellwords.escape(cmd)

      if options[:return] == true
        result = `#{ssh_command} -- #{script}`

      elsif simulate_mode?
        str = "Executing the following via '#{ssh_command}':"
        puts "#!/usr/bin/env bash"
        puts "# #{str}"
        puts "#"

        puts cmd

      else
        code = "#{ssh_command} -- #{script}"
        if settings.term_mode.to_s == 'pretty'
          result = pretty_system(code)
        elsif settings.term_mode.to_s == 'exec'
          exec code
        else
          system code
          result = $?.to_i
        end
      end

      die result if result.is_a?(Fixnum) && result > 0
      result
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
  end
end
