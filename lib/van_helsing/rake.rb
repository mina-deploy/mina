# This file is invoked from Rake.

$:.unshift File.expand_path('../../', __FILE__)
require File.expand_path('../../van_helsing', __FILE__)

extend VanHelsing::Helpers
extend VanHelsing::DeployHelpers

require 'van_helsing/default'
