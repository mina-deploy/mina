require 'rake'
Rake.application.options.trace = true

# require 'pry'
# require 'awesome_print'

require 'forwardable'
require 'shellwords'
require 'singleton'
require 'open4'

require 'mina/version'
require 'mina/helpers/output'
require 'mina/helpers/internal'
require 'mina/configuration'
require 'mina/dsl'
require 'mina/commands'
require 'mina/runner'
require 'mina/runner/pretty'
require 'mina/runner/system'
require 'mina/runner/exec'
require 'mina/runner/printer'
require 'mina/backend/local'
require 'mina/backend/remote'
require 'mina/windows_patches'
require 'mina/application'

module Mina
  def self.root_path(*args)
    File.join File.expand_path('../../', __FILE__), *args
  end
end
