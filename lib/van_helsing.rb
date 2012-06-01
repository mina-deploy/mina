require 'ostruct'

module VanHelsing
  PREFIX = File.dirname(__FILE__)
  ROOT = File.expand_path('../../', __FILE__)

  autoload :Helpers, 'van_helsing/helpers'

  def self.root_path(*a)
    File.join ROOT, *a
  end
end
