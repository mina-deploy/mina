module Mina
  class Commands
    extend Forwardable
    include Helpers::Internal
    include Configuration::DSL

    attr_reader :queue
    attr_accessor :stage

    def initialize(stage = :default)
      @stage = stage
      @queue = Hash.new { |hash, key| hash[key] = [] }
    end

    def command(code, strip: true, quiet: false, indent: nil)
      code = unindent(code) if strip
      code = indent(indent, code) if indent
      queue[stage] << (quiet ? code : echo_cmd(code))
    end

    def comment(code, indent: nil)
      if indent
        queue[stage] << indent(indent, %{echo "-----> #{code}"})
      else
        queue[stage] << %{echo "-----> #{code}"}
      end
    end

    def delete(stage)
      queue.delete(stage) || []
    end

    def process(path = nil)
      if path
        queue[stage].unshift(%{echo "$ cd #{path}"}) if fetch(:verbose)
        %{(cd #{path} && #{queue[stage].join(' && ')} && cd -)}
      else
        queue[stage].join("\n")
      end
    end

    def run_default?
      !queue.empty? && stage == :default
    end

    def run(backend)
      return if queue.empty?
      report_time do
        status = Mina::Runner.new(process, backend).run
        error! 'Run Error' unless status
      end
    end
  end
end
