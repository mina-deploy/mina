# frozen_string_literal: true

module Mina
  class Runner
    class Exec
      attr_reader :script

      def initialize(script)
        @script = script
      end

      def run
        Kernel.exec(script)
      end
    end
  end
end
