module Mina
  class Runner
    class System
      attr_reader :script

      def initialize(script)
        @script = script
      end

      def run
        Kernel.system(script)
      end
    end
  end
end
