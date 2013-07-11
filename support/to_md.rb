#!/usr/bin/env ruby
c = /(?:#|\/\/)/  # Comment prefix
lang = "ruby"     # Default language
blocks = STDIN.read.scan(/(?:^[ \t]*#{c} [^\n]*\n)+/)       # Read contiguous comments
blocks.map! { |s| s.gsub!(/(?:^|\n)+[ \t]*#{c} /, "\n") }   # Strip out prefixes

# Code blocks
md = blocks.join("")
md.gsub!(/((?:^    .*\n+)+)/) { |f| "~~~ #{lang}\n" + f.gsub(/^    /, '').gsub(/\s*$/, '') + "\n~~~\n\n" }

puts md
