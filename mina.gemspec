require './lib/mina/version'

Gem::Specification.new do |s|
  s.name = 'mina'
  s.version = Mina.version
  s.summary = 'Really fast deployer and server automation tool.'
  s.description = 'Really fast deployer and server automation tool.'
  s.authors = ['Stjepan Hadjić', 'Gabrijel Škoro', 'Rico Sta. Cruz', 'Michael Galero']
  s.email = [
    'stjepan.hadjic@infinum.co', 'gabrijel.skoro@infinum.co', 'rico@nadarei.co', 'mikong@nadarei.co'
  ]
  s.homepage = 'https://github.com/mina-deploy/mina'
  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir['bin/*'].map { |f| File.basename(f) }
  s.licenses = ['MIT']

  s.add_dependency 'rake'
  s.add_dependency 'open4', '~> 1.3.4'
  s.add_development_dependency 'rspec', '~> 3.0.0'
  s.add_development_dependency 'pry', '~> 0.9.0'
end
