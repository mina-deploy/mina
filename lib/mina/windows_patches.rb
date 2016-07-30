#if windows os
require 'rbconfig'
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
if is_windows
  module Shellwords
    def shellescape(str)
      '"' + str.gsub(/\\(?=\\*\")/, "\\\\\\").gsub(/\"/, "\\\"").gsub(/\\$/, "\\\\\\").gsub("%", "%%") + '"'
    end

    module_function :shellescape
    class << self
      alias escape shellescape
    end
  end
end
