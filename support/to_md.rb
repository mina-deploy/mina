#!/usr/bin/env ruby
c = /(?:#|\/\/)/  # Comment prefix
blocks = STDIN.read.scan(/(?:^[ \t]*#{c} [^\n]*\n)+/)       # Read contiguous comments
blocks.map! { |s| s.gsub!(/(?:^|\n)+[ \t]*#{c} /, "\n") }   # Strip out prefixes
puts blocks.join("")
