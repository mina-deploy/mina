lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

tasks = File.expand_path('../tasks', __FILE__)
$LOAD_PATH.unshift(tasks) unless $LOAD_PATH.include?(tasks)

require 'mina/version'

Gem::Specification.new do |spec|
  spec.name = 'mina'
  spec.version = Mina::VERSION
  spec.summary = 'Blazing fast application deployment tool.'
  spec.description = 'Blazing fast application deployment tool.'
  spec.authors = ['Stjepan Hadjić']
  spec.email = ['stjepan.hadjic@infinum.co']
  spec.homepage = 'https://github.com/mina-deploy/mina'
  spec.files = `git ls-files`.strip.split("\n")
  spec.executables = Dir['bin/*'].map { |f| File.basename(f) }
  spec.licenses = ['MIT']
  spec.require_paths = ['lib', 'tasks']

  spec.add_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.5.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
