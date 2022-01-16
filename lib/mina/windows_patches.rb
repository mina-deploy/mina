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

    def shellsplit(array)
      array.map { |arg| shellescape(arg) }.join(' ')
    end
    module_function :shelljoin
  end
end
