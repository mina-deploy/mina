# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'

  enable_coverage :branch
  primary_coverage :branch
end

require 'mina'
require 'rspec'
require 'pry'
require 'set'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }
Rake.application = Mina::Application.new
Dir['./tasks/mina/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.include RakeExampleGroup, type: :rake

  config.raise_errors_for_deprecations!
  config.order = 'random'

  initial_task_names = Rake.application.tasks.to_set(&:name)
  initial_variables = Mina::Configuration.instance.variables

  config.before do
    Mina::Configuration.instance.instance_variable_set(:@variables, initial_variables.clone)
  end

  config.after do
    Rake.application.instance_variable_get(:@tasks).keep_if { |task_name, _| initial_task_names.include?(task_name) }
    Rake.application.tasks.each(&:reenable)
  end

  config.around(:each, :suppressed_output) do |example|
    original_stdout, $stdout = $stdout, File.open(File::NULL, 'w')
    original_stderr, $stderr = $stderr, File.open(File::NULL, 'w')

    example.run

    $stdout, $stderr = original_stdout, original_stderr
  end

  config.around(:all) do |example|
    example.run
  rescue SystemExit
    raise "Unhandled system exit (you're probably missing a raise_error(SystemExit) matcher somewhere)"
  end
end
