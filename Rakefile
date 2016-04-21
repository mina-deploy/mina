require 'bundler'
require 'bundler/gem_tasks'

task :spec do
  system "rm Gemfile.lock; sh -c 'rake=0.8 bundle exec rspec'"
  system "rm Gemfile.lock; sh -c 'rake=0.9 bundle exec rspec'"
end

task default: :spec
