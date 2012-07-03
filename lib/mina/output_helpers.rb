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

    def print_command(msg)
      puts "       #{color("$", 32)} #{color(msg, 34)}"
    end

    def print_message(msg)
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
      cmds << "2>&1"

      status =
        Tools.popen4(*cmds) do |pid, i, o, e|
          i.close
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
              print_message str
            end
          end
        end
      status.exitstatus
    end
  end
end
