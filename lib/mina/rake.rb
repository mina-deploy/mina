# This file is invoked from Rake.
extend Mina::Helpers
extend Mina::DeployHelpers
extend Mina::SshHelpers
extend Mina::LocalHelpers
extend Mina::OutputHelpers
extend Mina::ExecHelpers

require 'mina/default'
require 'mina/deploy' if Rake.application.have_rakefile
