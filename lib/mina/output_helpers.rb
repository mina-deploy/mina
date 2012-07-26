module Mina
  module OutputHelpers
    # Protip! make a module that overrides these settings, then use `extend YourModule`
    # to make your own pretty printing thing.
    def print_status(msg)
      puts ""  if verbose_mode?
      puts "#{color('----->', 32)} #{msg}"
    end

    def print_error(msg)
      puts " #{color("!", 33)}     #{color(msg, 31)}"
    end

    def print_stderr(msg)
      puts "       #{color(msg, 31)}"
    end

    def print_command(msg)
      puts "       #{color("$", 32)} #{color(msg, 32)}"
    end

    def print_stdout(msg)
      puts "       #{msg}"
    end

    # Internal: Colorizes a string.
    # Returns the string `str` with the color `c`.
    def color(str, c)
      ENV['NO_COLOR'] ? str : "\033[#{c}m#{str}\033[0m"
    end

    # Internal: Prints a string by delegating it to the proper output helper.
    #
    # It takes an input with text and prints them nicely. The text block can
    # have statuses (prefixed with `-----> `), errors (prefixed with `! `),
    # commands (prefixed with `$ `) or anything else. Depending on the type of
    # the message, they will be delegated to the proper print_* helper.
    #
    #     -----> Unlocking
    #     $ unlock foo
    #     Unlocked.
    #     ! ERROR: Failed
    #
    # Returns nothing.
    #
    def print_str(str)
      if str =~ /^\-+> (.*?)$/
        print_status $1
      elsif str =~ /^! (.*?)$/
        print_error $1
      elsif str =~ /^\$ (.*?)$/
        print_command $1
      else
        print_stdout str
      end
    end

    # Internal: Works like `system`, but indents and puts color.
    #
    # Returns the exit code in integer form.
    #
    def pretty_system(code)
      require 'shellwords'
      cmds = Shellwords.shellsplit(code)
      interrupted = false

      status =
        Tools.popen4(*cmds) do |pid, i, o, e|
          trap "INT" do
            puts ""
            unless interrupted
              print_status "Mina: SIGINT received."
              Process.kill "TERM", pid
              interrupted = true
            else
              print_status "Mina: SIGINT received again. Force quitting..."
              Process.kill "KILL", pid
            end
          end

          # Read stderr in the background.
          p1 = fork do
            trap("INT") {}
            while str = e.gets
              # Supress expected errors.
              next if str.include? "bash: no job control in this shell"
              next if str.include? "stdin is not a terminal"
              print_stderr str.strip
            end
          end

          # Read stdout.
          while str = o.gets
            print_str str
          end

          Process.waitpid p1
        end

      status.exitstatus
    end
  end
end
