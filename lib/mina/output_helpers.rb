module Mina
  module OutputHelpers
    # Protip! make a module that overrides these settings, then use `extend YourModule`
    # to make your own pretty printing thing.
    def print_status(msg)
      puts "-----> #{msg}"
    end

    def print_error(msg)
      puts " #{color("!", 33)}     #{color(msg, 31)}"
    end

    def print_stderr(msg)
      puts "       #{color(msg, 31)}"
    end

    def print_command(msg)
      puts "       #{color("$", 32)} #{color(msg, 34)}"
    end

    def print_stdout(msg)
      puts "       #{msg}"
    end

    # Internal: Colorizes a string.
    #
    # Returns the string `str` with the color `c`.
    def color(str, c)
      if ENV['NO_COLOR']
        str
      else
        "\033[#{c}m#{str}\033[0m"
      end
    end

    # Internal: Works like `system`, but indents and puts color.
    #
    # Returns the exit code in integer form.
    #
    def pretty_system(code)
      require 'shellwords'
      cmds = Shellwords.shellsplit(code)

      status =
        Tools.popen4(*cmds) do |pid, i, o, e|
          # Close stdin so that we can move on.
          i.close

          # Read stderr in the background.
          p1 = fork do
            while str = e.gets
              # Supress expected errors.
              next if str.include? "bash: no job control in this shell"
              next if str.include? "stdin is not a terminal"
              print_stderr str.strip
            end
          end

          # Read stdout.
          while str = o.gets
            if str =~ /^-----> (.*?)$/
              print_status $1
            elsif str =~ /^=====> (.*?)$/
              print_error $1
            elsif str =~ /^ *\! +(.*?)$/
              print_error $1
            elsif str =~ /^\$ (.*?)$/
              print_command $1
            else
              print_stdout str
            end
          end

          Process.waitpid(p1)
        end
      status.exitstatus
    end
  end
end
