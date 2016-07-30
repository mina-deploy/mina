module Mina
  module Backend
    class Local
      include Configuration::DSL
      attr_reader :commands

      def initialize(commands)
        @commands = commands
      end

      def prepare
        if fetch(:simulate)
          ['#!/usr/bin/env bash', '# Executing the following:', '#', commands, ' '].join("\n")
        else
          Shellwords.escape(commands)
        end
      end
    end
  end
end
