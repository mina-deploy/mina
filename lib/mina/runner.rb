module Mina
  class Runner
    attr_reader :commands, :backend
    include Configuration::DSL

    def initialize(commands, backend)
      fail 'You must specify execution mode' if execution_mode.nil?
      fail 'Unsuported execution mode (pretty on windows)' if unsuported_execution_mode?
      @backend = backend
      @commands = commands
    end

    def run
      Mina::Runner.const_get(class_name_for(execution_mode)).new(script).run
    end

    def execution_mode
      @execution_mode ||=
      if fetch(:simulate)
        :printer
      else
        fetch(:execution_mode)
      end
    end

    private

    def script
      Mina::Backend.const_get(class_name_for(backend)).new(commands).prepare
    end

    def unsuported_execution_mode?
      execution_mode == :pretty && Gem::Platform.local.os == :windows
    end

    def class_name_for(symbol)
      symbol.to_s.split('_').map(&:capitalize).join
    end
  end
end
