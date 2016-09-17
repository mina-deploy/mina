module Mina
  module DSL
    attr_reader :commands

    extend Forwardable
    def_delegators :configuration, :fetch, :set, :set?, :ensure!
    def_delegators :commands, :command, :comment

    def configuration
      Configuration.instance
    end

    def invoke(task, *args)
      Rake::Task[task].invoke(*args)
      Rake::Task[task].reenable
    end

    def commands
      @commands ||= Commands.new
    end

    def reset!
      @commands = Commands.new
    end

    def run(backend)
      # @commands = Commands.new
      invoke :environment if backend == :remote
      yield
      commands.run(backend)
      @commands = Commands.new
    end

    def on(stage)
      old_stage, commands.stage = commands.stage, stage
      yield
      commands.stage = old_stage
    end

    def in_path(path, indent: nil)
      real_commands = commands
      @commands = Commands.new
      yield
      real_commands.command(commands.process(path), quiet: true, indent: indent)
      @commands = real_commands
    end

    def deploy(&block)
      run :remote do
        command deploy_script(&block), quiet: true
      end
    end
  end
end
extend Mina::DSL
