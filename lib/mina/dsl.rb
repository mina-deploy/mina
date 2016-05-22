module Mina
  module DSL
    attr_reader :commands

    extend Forwardable
    def_delegators :configuration, :fetch, :set, :set?, :ensure!
    def_delegators :commands, :command, :comment, :command_without_verbose

    def configuration
      Configuration.instance
    end

    def commands
      Commands.instance
    end

    def invoke(task, *args)
      Rake::Task[task].invoke(*args)
      Rake::Task[task].reenable
    end

    def run(locality = :local)
      old_commands_params = save_commands_params(locality: locality)
      yield
      restore_commands_params(old_commands_params)
    end

    def run_commands
      commands.run
    end

    def on(queue_name = :default)
      old_commands_params = save_commands_params(queue_name: queue_name)
      yield
      restore_commands_params(old_commands_params)
    end

    def in_path(path = '')
      old_commands_params = save_commands_params(path: path)
      yield
      restore_commands_params(old_commands_params)
    end

    def deploy(&block)
      set :execution_mode, :pretty
      run :remote do
        command_without_verbose deploy_script(&block)
      end
    end
  end
end
extend Mina::DSL
