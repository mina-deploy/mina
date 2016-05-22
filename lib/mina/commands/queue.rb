module Mina
  class Commands
    class Queue
      attr_accessor :elements

      def initialize
        @elements = []
      end

      def find(params)
        return add_new_element(params) if elements.empty?
        elements.find { |element| element.params == params } || add_new_element(params)
      end

      def fetch(params)
        deleted, @elements = elements.partition { |element| element.params == params }
        deleted.map(&:process) || Element.new(params)
      end

      def add_new_element(params)
        @elements << Element.new(params)
        elements.last
      end

      def run(command_run_order)
        command_run_order.each do |param_array|
          param = Params.new(*param_array)
          commands = elements.select { |element| element.params == param }
          next if commands.empty?
          Mina::Runner.new(commands.map(&:process).join("\n"), param.locality).run
        end
      end
    end
  end
end
