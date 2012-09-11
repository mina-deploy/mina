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
          trap("INT") { handle_sigint(coathooks += 1) }

          # __In the background,__ make stdin passthru, and stream stderr.
          pid_err = stream_stderr!(e) { |str| print_stderr str }
          pid_in  = stream_stdin!     { |chr| i.putc chr }

          # __In the foreground,__ stream stdout to the output helper.
          stream_stdout(o) { |str| print_str str }

          Process.waitpid pid_err
        end

      status.exitstatus
    end

  private

    # ## Private methods
    # `pretty_system` delegates to these.

    # ### handle_sigint!(count)
    # Called when a `^C` is pressed. The param `count` is how many times it's
    # been pressed since. Returns nothing.

    def handle_sigint(count)
      puts ""
      if count > 1
        print_status "Mina: SIGINT received again. Force quitting..."
        Process.kill "KILL", pid
      else
        print_status "Mina: SIGINT received."
        Process.kill "TERM", pid
      end
    end

    # ### stream_stderr!
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

    # ### stream_stdin!
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

    # ### stream_stdout
    # __Internal:__ Read from given stdout stream `o` and delegate it to the
    # output helper.

    def stream_stdout(o, &blk)
      while str = o.gets
        yield str
      end
    end

  end
end
