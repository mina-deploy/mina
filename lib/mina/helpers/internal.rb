module Mina
  module Helpers
    module Internal
      def save_commands_params(locality: nil, queue_name: nil, path: nil)
        params = commands.params
        commands.params =
          Commands::Params.new(
            locality || params.locality,
            queue_name || params.queue_name,
            path || params.path
          )
        params
      end

      def restore_commands_params(params)
        commands.params = params
      end

      def deploy_script
        yield
        erb Mina.root_path('data/deploy.sh.erb')
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

      def unindent(code)
        code = code.gsub(/^#{Regexp.last_match[1]}/, '') if code =~ /^\n([ \t]+)/
        code.strip
      end

      def reindent(n, code)
        indent n, unindent(code)
      end
    end
  end
end
extend Mina::Helpers::Internal
