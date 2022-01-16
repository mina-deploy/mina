# frozen_string_literal: true

require 'rbconfig'
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
if is_windows
  module Shellwords
    def shellescape(str)
      return '""' if str.empty?

      if str =~ /\s/
        "\"#{str.gsub('"', '""')}\""
      else
        str
      end
    end
    module_function :shellescape
  end
end
