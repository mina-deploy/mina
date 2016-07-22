module Mina
  module Helpers
    module Internal
      def deploy_script
        yield
        erb Mina.root_path(fetch(:deploy_script))
      end

      def erb(file, b = binding)
        require 'erb'
        erb = ERB.new(File.read(file))
        erb.result b
      end

      def echo_cmd(code, ignore_verbose = false)
        if Mina::Configuration.instance.fetch(:verbose) && !ignore_verbose
          "echo #{Shellwords.escape('$ ' + code)} &&\n#{code}"
        else
          code
        end
      end

      def indent(count, str)
        str.gsub(/^/, ' ' * count)
      end

      def report_time
        time_start = Time.now
        yield
        puts "Elapsed time: %.2f seconds" % [Time.now - time_start]
      end
    end
  end
end
extend Mina::Helpers::Internal
