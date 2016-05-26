require 'rake'
Rake.application.options.trace = true

require 'pry'
# require 'awesome_print'

require 'forwardable'
require 'shellwords'
require 'singleton'
require 'open4'

require 'mina/version'
require 'mina/configuration'
require 'mina/dsl'
require 'mina/helpers/output'
require 'mina/helpers/internal'
require 'mina/commands'
require 'mina/runner'
require 'mina/runner/pretty'
require 'mina/runner/system'
require 'mina/runner/exec'
require 'mina/runner/printer'
require 'mina/backend/local'
require 'mina/backend/remote'
require 'mina/application'

module Mina
  # Error = Class.new(Exception)
  # class Failed < Error
  #   attr_accessor :exitstatus
  # end
  #
  def self.root_path(*args)
    File.join File.expand_path('../../', __FILE__), *args
  end
end
