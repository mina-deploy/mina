module Mina
  class Runner
    class Pretty
      include Mina::Helpers::Output

      attr_reader :script, :coathooks

      def initialize(script)
        @script = Shellwords.shellsplit(script)
        @coathooks = 0
      end

      def run
        status =
          Open4.popen4(*script) do |pid, _stdin, stdout, stderr|
            # Handle `^C`.
            trap('INT') { handle_sigint(pid) }

            stdout_thread = Thread.new do
              while (line = stdout.gets)
                print_line(line)
              end
            end

            stderr_thread = Thread.new do
              while (line = stderr.gets)
                print_line(line)
              end
            end

            stdout_thread.join
            stderr_thread.join
          end

        status.exitstatus
      end

      private

      def handle_sigint(pid)
        puts ''
        if coathooks > 1
          print_status 'Mina: SIGINT received again. Force quitting...'
          Process.kill 'KILL', pid
        else
          print_status 'Mina: SIGINT received.'
          Process.kill 'TERM', pid
        end
        @coathooks += 1
      end

      # def stream_stderr!(err)
      #   Thread.new do
      #     begin
      #       while str = err.gets #[0]
      #         next if str.include? 'bash: no job control in this shell' #[1]
      #         next if str.include? 'stdin is not a terminal'
      #
      #         yield str.strip #[2]
      #       end
      #     rescue Interrupt
      #     end
      #   end
      # end
      #
      # def stream_stdin!
      #   Thread.new do
      #     begin
      #       while (char = STDIN.getbyte rescue nil)
      #         yield char if char
      #       end
      #     rescue Interrupt
      #     # rubinius
      #     rescue SignalException
      #     end
      #   end
      # end
    end
  end
end
