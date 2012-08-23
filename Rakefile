require 'bundler'
require 'bundler/gem_tasks'

github = ENV['github'] || 'nadarei/mina'

task :spec do
  system "rm Gemfile.lock; sh -c 'rake=0.8 bundle exec rspec'"
  system "rm Gemfile.lock; sh -c 'rake=0.9 bundle exec rspec'"
end

task :docs do
  files = ['manual/index.md', 'manual/modules.md', 'HISTORY.md'] + Dir['lib/**/*.rb']
  system "lidoc #{files.join ' '} -o docs --github #{github}"
end

task :'docs:deploy' => :docs do
  system "git-update-ghpages #{github} -i docs -p docs"
end

task :default => :spec
