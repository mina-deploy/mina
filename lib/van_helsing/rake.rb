# This file is invoked from Rake.
extend VanHelsing::Helpers
extend VanHelsing::DeployHelpers

require 'van_helsing/default'
require 'van_helsing/deploy' if Rake.application.have_rakefile
