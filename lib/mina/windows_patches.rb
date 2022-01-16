# frozen_string_literal: true

if Mina::OS.windows?
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
