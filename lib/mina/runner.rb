module Mina
  class Runner
    attr_reader :commands, :locality

    def initialize(commands, locality)
      fail 'You must specify execution mode' if execution_mode.nil?
      fail 'Unsuported execution mode (pretty on windows)' if unsuported_execution_mode?
      @locality = locality
      @commands = commands
    end

    def run
      Mina::Runner.const_get(class_name_for(execution_mode)).new(script).run
    end

    private

    def execution_mode
      @execution_mode ||=
        if Mina::Configuration.instance.fetch(:simulate)
          :printer
        else
          Mina::Configuration.instance.fetch(:execution_mode)
        end
    end

    def script
      Mina::Backend.const_get(class_name_for(locality)).new(commands).prepare
    end

    def unsuported_execution_mode?
      execution_mode == :pretty && Gem::Platform.local.os == :windows
    end

    def class_name_for(symbol)
      symbol.to_s.split('_').map(&:capitalize).join
    end
  end
end
