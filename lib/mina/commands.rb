module Mina
  class Commands
    include Singleton
    extend Forwardable

    attr_accessor :queue, :params
    def_delegators :queue, :find, :fetch

    def initialize
      @params = Params.new(:remote, :default, nil)
      @queue = Queue.new
    end

    def command(code)
      queue.find(params).add(code)
    end

    def command_without_verbose(code)
      params.ignore_verbose!
      queue.find(params).add(code)
    end

    def comment(code)
      queue.find(params).add("echo '-----> #{code}'")
    end

    def run
      queue.run(
        Mina::Configuration.instance.fetch(
          :command_run_order,
          [[:local, :before], [:remote], [:local, :after]]
        )
      )
    end
  end
end
