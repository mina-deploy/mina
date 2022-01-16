# frozen_string_literal: true

require 'rbconfig'

module Mina
  module OS
    def self.windows?
      RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
    end
  end
end
