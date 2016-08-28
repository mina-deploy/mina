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
                print_stderr(line)
              end
            end

            stdout_thread.join
            stderr_thread.join
          end

        status.exitstatus == 0
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
    end
  end
end
