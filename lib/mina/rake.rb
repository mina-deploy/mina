# This file is invoked from Rake.
extend Mina::Helpers
extend Mina::DeployHelpers

require 'mina/default'
require 'mina/deploy' if Rake.application.have_rakefile
