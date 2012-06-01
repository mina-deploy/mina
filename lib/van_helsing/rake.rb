$:.unshift File.expand_path('../../', __FILE__)
require File.expand_path('../../van_helsing', __FILE__)

extend VanHelsing::Helpers

require 'van_helsing/recipes/default'
