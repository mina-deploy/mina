# # Helpers: Local helpers
# You don't need to invoke these helpers, they're already invoked automatically.

module Mina
  module LocalHelpers
    # ### local
    # Executes a command.
    #
    # Returns nothing usually, but if `{ return: true }` is given, returns the
    # STDOUT output.
    #
    # `options` is a hash of options:
    #
    #  - `:pretty` - Prettify the output if true.
    #  - `:return`  - If set to true, returns the output.
    #
    # Example
    #
    #     local("ls", return: true)

    def local(cmd, options = {})
      script = cmd.join("\n") if cmd.is_a?(Array)

      if options[:return] == true
        `#{script}`
      elsif simulate_mode?
        Local.simulate(script)
      else
        result = Local.invoke(script, self)
        Local.ensure_successful result, self
      end
    end

    # ## Private methods
    # `local` delegates to these.

    module Local
      extend self

      # ### Local.simulate
      # __Internal:__ Prints command.

      def simulate(cmd)
        str = "Executing the following:"
        puts "#!/usr/bin/env bash"
        puts "# #{str}"
        puts "#"

        puts cmd

        0
      end

      # ### Local.invoke
      # __Internal:__ Initiates an SSH session with script `script` with given
      # `term_mode`.  Called by `local`.

      def invoke(script, this)
        # Ruby 1.8.7 doesn't let you have empty symbols
        term_mode = :"#{this.settings.term_mode}" if this.settings.term_mode
        code = "#{script}"

        # Certain environments can't do :pretty mode.
        term_mode = :exec if term_mode == :pretty && !pretty_supported?

        case term_mode
        when :pretty
          require 'shellwords'
          code = Shellwords.escape(code)
          this.pretty_system(code)
        when :exec
          Kernel.exec code
        else
          Kernel.system code
          $?.exitstatus
        end
      end

      # TODO: Move to concern
      def pretty_supported?
        # open4 is not supported under Windows.
        # https://github.com/nadarei/mina/issues/58
        require 'rbconfig'
        ! (RbConfig::CONFIG['host_os'] =~ /mswin|mingw/)
      end

      # ### Local.ensure_successful
      # __Internal:__ Halts the execution if the given result code is not
      # successful (non-zero).

      def ensure_successful(result, this)
        this.die result if result.is_a?(Fixnum) && result > 0
        result
      end
    end
  end
end
