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
        status = nil
        begin
          pid, stdin, stdout, stderr = (RUBY_PLATFORM =~ /java/ ? IO : Open4).send(:popen4, *script)
          #Open4.popen4(*script) do |pid, _stdin, stdout, stderr|
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

          p, status = Process.waitpid2(pid) if still_alive?(pid)
          
          not (status.nil? || status.exitstatus != 0)
        rescue => e
          print_status "Mina: Got error: #{e.message}"
          false
        end
      end

      private

      
      def still_alive?(pid)
        begin
          Process.getpgid(pid)
          true
        rescue Errno::ESRCH
          false
        end
      end
      
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
