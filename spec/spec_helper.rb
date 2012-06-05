require 'rubygems' unless Object.const_defined?(:Gem)
gem 'rake', "~> #{ENV['rake']}.0" if ENV['rake']

require 'van_helsing'
require 'rake'

puts "Testing with Rake #{Gem.loaded_specs['rake'].version}"

class RakeScope
  include Rake::DSL  if Rake.const_defined?(:DSL)
  include VanHelsing::Helpers
end

def rake(&blk)
  if block_given?
    @scope ||= RakeScope.new
    @scope.instance_eval &blk
  end

  @scope
end

def root(*a)
  File.join File.expand_path('../../', __FILE__), *a
end
