module Mina
  class Configuration
    include Singleton
    include Helpers::Internal

    module DSL
      def self.included(base)
        [:set, :fetch, :remove, :set?, :ensure!, :reset!].each do |method|
          base.send :define_method, method do |*args,  &block|
            Configuration.instance.send(method, *args, &block)
          end
        end
      end
    end

    attr_reader :variables

    def initialize
      @variables ||= {}
    end

    def set(key, value = nil, &block)
      variables[key] = block || value
    end

    def fetch(key, default = nil)
      value = ENV[key.to_s] || variables.fetch(key, default)
      value.respond_to?(:call) ? value.call : value
    end

    def remove(key)
      variables.delete(key)
    end

    def set?(key)
      ENV.has_key?(key.to_s) || !variables.fetch(key, nil).nil?
    end

    def ensure!(key)
      error! "#{key} must be defined!" unless set?(key)
    end

    def reset!
      @variables = {}
    end
  end
end
