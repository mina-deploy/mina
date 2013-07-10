# # Helpers: Output helpers
# Protip! make a module that overrides these settings, then use `extend YourModule`
# to make your own pretty printing thing.
module Mina
  module OutputHelpers

    # ### print_str
    # Prints a string by delegating it to the proper output helper.
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
    def print_str(line)
      if line =~ /^\-+> (.*?)$/
        print_status $1
      elsif line =~ /^! (.*?)$/
        print_error $1
      elsif line =~ /^\$ (.*?)$/
        print_command $1
      else
        print_stdout line
      end
    end

    # ### print_char
    # Prints a single character.
    def print_char(ch)
      $last ||= ''

      if ch == "\n"
        print_clear
        print_str $last
        $last = ''
      else
        print '       ' if $last == ''
        print ch
        $last += ch
      end
    end

    def print_clear
      print "\033[1K\r"
    end

    # ### print_status
    # Prints a status message. (`----->`)
    def print_status(msg)
      puts ""  if verbose_mode?
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
      puts "       #{color("$", 32)} #{color(msg, 32)}"
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
