require 'mina'
require 'rake'

RSpec.configure do |config|
  config.order = 'random'
  config.seed = '12345'
end

class RakeScope
  include Rake::DSL  if Rake.const_defined?(:DSL)
  include Mina::Helpers
  include Mina::SshHelpers
  include Mina::LocalHelpers
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

