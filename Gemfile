# Why use bundler?
# Well, not all development dependencies install on all rubies. Moreover, `gem
# install mina --development` doesn't work, as it will also try to install
# development dependencies of our dependencies, and those are not conflict free.
# So, here we are, `bundle install`.

source "https://rubygems.org"
gemspec

gem 'rake', "~> #{ENV['rake'] || "0.9"}.0"
