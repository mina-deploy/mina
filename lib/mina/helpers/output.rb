module Mina
  module Helpers
    module Output
      # def print_character(character)
      #   @last ||= ''
      #
      #   if character == "\n"
      #     print_clear
      #     print_line @last
      #     @last = ''
      #   else
      #     print '       ' if @last == ''
      #     print character
      #     @last += character
      #   end
      # end

      def print_line(line)
        case line
        when /^\-+> (.*?)$/
          print_status Regexp.last_match[1]
        when /^! (.*?)$/
          print_error Regexp.last_match[1]
        when /^\$ (.*?)$/
          print_command Regexp.last_match[1]
        else
          print_stdout line
        end
      end

      # def print_clear
      #   print "\033[1K\r"
      # end

      # ### print_status
      # Prints a status message. (`----->`)
      def print_status(msg)
        puts "#{color('----->', 32)} #{msg}"
      end

      # ### print_error
      # Prints an error message (header).
      def print_error(msg)
        puts " #{color("!", 33)}     #{color(msg, 31)}"
      end

      # ### print_stderr
      # Prints an error message (body), or prints stderr output.
      def print_stderr(msg)
        puts "       #{color(msg, 31)}"
      end

      # ### print_command
      # Prints a command.
      def print_command(msg)
        puts "       #{color('$', 36)} #{color(msg, 36)}"
      end

      # ### print_stdout
      # Prints a normal message.
      def print_stdout(msg)
        puts "       #{msg}"
      end

      # ### color
      # Colorizes a string.
      # Returns the string `str` with the color `c`.
      def color(str, c)
        ENV['NO_COLOR'] ? str : "\033[#{c}m#{str}\033[0m"
      end
    end
  end
end
