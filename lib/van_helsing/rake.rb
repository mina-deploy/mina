# This file is invoked from Rake.
extend VanHelsing::Helpers
extend VanHelsing::DeployHelpers

# Inherit settings from Rake. Hehe.
set :verbose_mode, (Rake.verbose == true)
set :simulate_mode, (!! ENV['simulate'])

require 'van_helsing/default'
