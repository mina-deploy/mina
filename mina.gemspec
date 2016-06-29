lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

tasks = File.expand_path('../tasks', __FILE__)
$LOAD_PATH.unshift(tasks) unless $LOAD_PATH.include?(tasks)

require 'mina/version'

Gem::Specification.new do |spec|
  spec.name = 'mina'
  spec.version = Mina::VERSION
  spec.summary = 'Really fast deployer and server automation tool.'
  spec.description = 'Really fast deployer and server automation tool.'
  spec.authors = ['Stjepan Hadjić', 'Gabrijel Škoro', 'Rico Sta. Cruz', 'Michael Galero']
  spec.email = [
    'stjepan.hadjic@infinum.co', 'gabrijel.skoro@infinum.co', 'rico@nadarei.co', 'mikong@nadarei.co'
  ]
  spec.homepage = 'https://github.com/mina-deploy/mina'
  spec.files = `git ls-files`.strip.split("\n")
  spec.executables = Dir['bin/*'].map { |f| File.basename(f) }
  spec.licenses = ['MIT']
  spec.require_paths = ['lib']

  spec.add_dependency 'rake'
  spec.add_dependency 'open4', '~> 1.3.4'
  spec.add_development_dependency 'rspec', '~> 3.0.0'
  spec.add_development_dependency 'pry', '~> 0.9.0'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
