# This file is invoked from Rake.
extend Mina::Helpers
extend Mina::DeployHelpers
extend Mina::SshHelpers
extend Mina::OutputHelpers
extend Mina::ExecHelpers
extend Mina::RsyncHelpers

require 'mina/default'
require 'mina/deploy' if Rake.application.have_rakefile
