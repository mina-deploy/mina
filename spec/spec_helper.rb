require 'simplecov'

SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'mina'
require 'rspec'
require 'pry'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
Rake.application = Mina::Application.new
Dir["./tasks/mina/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include RakeExampleGroup, type: :rake

  config.raise_errors_for_deprecations!
  config.order = 'random'

  config.before(:all, type: :rake) do
    Mina::Configuration.instance.set :simulate, true
    Mina::Configuration.instance.set :domain, 'localhost'
    Mina::Configuration.instance.set :deploy_to, "#{Dir.pwd}/deploy"
    Mina::Configuration.instance.set :repository, "#{Mina.root_path}"
    Mina::Configuration.instance.set :shared_paths, ['config/database.yml', 'log']
    Mina::Configuration.instance.set :keep_releases, 2
  end

  config.after(:all, type: :rake) do
    Mina::Configuration.instance.remove :simulate
  end

  config.around(:each, :suppressed_output) do |example|
    original_stdout, $stdout = $stdout, File.open(File::NULL, 'w')
    original_stderr, $stderr = $stderr, File.open(File::NULL, 'w')

    example.run

    $stdout, $stderr = original_stdout, original_stderr
  end

  config.around(:all) do |example|
    begin
      example.run
    rescue SystemExit => e
      raise "Unhandled system exit (you're probably missing a raise_error(SystemExit) matcher somewhere)"
    end
  end
end
