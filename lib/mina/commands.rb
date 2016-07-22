module Mina
  class Commands
    extend Forwardable
    include Helpers::Internal

    attr_reader :queue
    attr_accessor :stage
    def_delegators :queue, :find, :fetch, :process

    def initialize(stage = :default)
      @stage = stage
      @queue = Hash.new { |hash, key| hash[key] = [] }
    end

    def command(code, quiet: false, indent: nil)
      code = indent(indent, code) if indent
      queue[stage] << (quiet ? code : echo_cmd(code))
    end

    def comment(code, indent: nil)
      if indent
        queue[stage] << indent(indent, "echo '-----> #{code}'")
      else
        queue[stage] << "echo '-----> #{code}'"
      end
    end

    def fetch(stage)
      queue.delete(stage) || []
    end

    def process(path = nil)
      if path
        queue[stage].unshift("echo '$ cd #{path}'") if Mina::Configuration.instance.fetch(:verbose)
        "(cd #{path} && #{queue[stage].join(' && ')})"
      else
        fetch(stage).join("\n")
      end
    end

    def run(backend)
      report_time do
        Mina::Runner.new(process, backend).run
      end
    end
  end
end
