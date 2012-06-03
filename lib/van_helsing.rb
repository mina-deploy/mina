module VanHelsing
  PREFIX = File.dirname(__FILE__)
  ROOT = File.expand_path('../../', __FILE__)

  require 'van_helsing/version'

  autoload :Helpers, 'van_helsing/helpers'
  autoload :Settings, 'van_helsing/settings'

  Error = Class.new(Exception)
  class Failed < Error
    attr_accessor :exitstatus
  end

  def self.root_path(*a)
    File.join ROOT, *a
  end
end
