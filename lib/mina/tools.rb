module Mina
  module Tools
    if IO.respond_to?(:popen4)
      def self.popen4(*cmd, &blk)
        IO.popen4 *cmd, &blk
        $?
      end
    else
      def self.popen4(*cmd, &blk)
        require 'open4'
        Open4.popen4 *cmd, &blk
      end
    end

    def self.pfork4(*cmd, &blk)
      require 'open4'
      Open4.pfork4 *cmd, &blk
    end
  end
end
