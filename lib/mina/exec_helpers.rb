# # Helpers: Exec helpers
# Provides `pretty_system` which Mina uses to parse SSH output, and delegate to
# the appropriate Output helper.

module Mina
  module ExecHelpers

    # ### pretty_system
    # __Internal:__ A pretty version of the default `#system` commands, but
    # indents and puts color.
    #
    # Returns the exit code in integer form.
    #
    def pretty_system(code)
      require 'shellwords'
      cmds = Shellwords.shellsplit(code)
      coathooks = 0

      status =
        Tools.popen4(*cmds) do |pid, i, o, e|
          # Handle `^C`.
          trap("INT") { Sys.handle_sigint(coathooks += 1, pid, self) }

          # __In the background,__ make stdin passthru, and stream stderr.
          pid_err = Sys.stream_stderr!(e) { |str| print_stderr str }
          pid_in  = Sys.stream_stdin!     { |chr| i.putc chr }

          # __In the foreground,__ stream stdout to the output helper.
          Sys.stream_stdout(o) { |ch| print_char ch }

          Process.waitpid pid_err
          Process.kill 'TERM', pid_in
        end

      status.exitstatus
    end

    # ## Private methods
    # Delegate functions, mostly.

    module Sys

      extend self

      # ### Sys.handle_sigint!
      # Called when a `^C` is pressed. The param `count` is how many times it's
      # been pressed since. Returns nothing.

      def handle_sigint(count, pid, this)
        puts ""
        if count > 1
          this.print_status "Mina: SIGINT received again. Force quitting..."
          Process.kill "KILL", pid
        else
          this.print_status "Mina: SIGINT received."
          Process.kill "TERM", pid
        end
      end

      # ### Sys.stream_stderr!
      # __Internal:__ Read from stderr stream `err` *[0]*, supress expected
      # errors *[1]*, and yield. Returns the PID.

      def stream_stderr!(err, &blk)
        fork do
          trap("INT") {}

          while str = err.gets #[0]
            next if str.include? "bash: no job control in this shell" #[1]
            next if str.include? "stdin is not a terminal"

            yield str.strip #[2]
          end
        end
      end

      # ### Sys.stream_stdin!
      # __Internal:__ Read from the real stdin stream and pass it onto the given
      # stdin stream `i`. Returns the PID.

      def stream_stdin!(&blk)
        fork do
          trap("INT") {}

          while (char = STDIN.getbyte rescue nil)
            yield char if char
          end
        end
      end

      # ### Sys.stream_stdout
      # __Internal:__ Read from given stdout stream `o` and delegate it to the
      # output helper.

      def stream_stdout(o, &blk)
        while str = o.getc
          yield str
        end
      end

    end

  end
end
