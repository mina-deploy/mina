module Mina
  class Runner
    class Pretty
      include Mina::Helpers::Output

      attr_reader :script

      def initialize(script)
        @script = script
        @coathooks = 0
      end

      def run
        exit_status = nil 

        Open3.popen3(script) do |_stdin, stdout, stderr, wait_thr|
          pid = wait_thr.pid

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

          exit_status = wait_thr.value
        end

        exit_status.success?
      end

      private

      def handle_sigint(pid)
        puts ''
        if @coathooks > 1
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
