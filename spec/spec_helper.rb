require 'codeclimate-test-reporter'
require 'simplecov'

CodeClimate::TestReporter.start
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'mina'
require 'rspec'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include RunHelper

  config.raise_errors_for_deprecations!
  config.order = 'random'

  config.after(:each) do
    Mina::Configuration.instance.reset!
  end
end
