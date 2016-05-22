module Mina
  class Commands
    class Params
      LOCALITIES = [:remote, :local]

      attr_accessor :queue_name, :path, :ignore_verbose
      attr_reader :locality

      def initialize(locality = nil, queue_name = nil, path = nil)
        @queue_name = queue_name
        @path = path
        @ignore_verbose = false
        self.locality = locality
      end

      def locality=(value)
        fail "Unknown locality: #{value}" unless LOCALITIES.include?(value)
        @locality = value
      end

      def ignore_verbose!
        @ignore_verbose = true
      end

      def ==(other)
        [
          other.queue_name.nil? ? nil : queue_name == other.queue_name,
          other.locality.nil? ? nil : locality == other.locality,
          other.path.nil? ? nil : path == other.path
        ].compact.all?
      end
    end
  end
end
