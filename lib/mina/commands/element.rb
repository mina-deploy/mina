module Mina
  class Commands
    class Element
      extend Forwardable
      include Helpers::Internal

      attr_reader :params, :commands

      def_delegators :commands, :map

      def initialize(params)
        @params = params
        @commands = []
      end

      def add(code)
        @commands << code
      end

      def process
        if params.path.nil?
          commands.map do|command|
            echo_cmd(command, params.ignore_verbose)
          end
        else
          commands.map do |command|
            echo_cmd("cd #{params.path} && #{command}", params.ignore_verbose)
          end
        end.join("\n")
      end
    end
  end
end
