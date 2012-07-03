# This file is invoked from Rake.
extend Mina::Helpers
extend Mina::DeployHelpers
extend Mina::OutputHelpers

require 'mina/default'
require 'mina/deploy' if Rake.application.have_rakefile
