require 'bundler'
require 'bundler/gem_tasks'

task :spec do
  system "rm Gemfile.lock; sh -c 'rake=0.8 bundle exec rspec'"
  system "rm Gemfile.lock; sh -c 'rake=0.9 bundle exec rspec'"
end

task :docs do
  files = ['README.md'] + Dir['lib/**/*.rb']
  system "lidoc #{files.join ' '} -o docs --github nadarei/mina"
end

task :default => :spec
