module Mina
  PREFIX = File.dirname(__FILE__)
  ROOT = File.expand_path('../../', __FILE__)

  require 'mina/version'

  autoload :DeployHelpers, 'mina/deploy_helpers'
  autoload :OutputHelpers, 'mina/output_helpers'
  autoload :SshHelpers, 'mina/ssh_helpers'
  autoload :LocalHelpers, 'mina/local_helpers'
  autoload :ExecHelpers, 'mina/exec_helpers'
  autoload :Helpers, 'mina/helpers'
  autoload :Settings, 'mina/settings'
  autoload :Tools, 'mina/tools'

  Error = Class.new(Exception)
  class Failed < Error
    attr_accessor :exitstatus
  end

  def self.root_path(*a)
    File.join ROOT, *a
  end
end
