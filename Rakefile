require 'bundler'
require 'bundler/gem_tasks'

# Do these:
#
#     * do `gem install reacco`
#     * install http://github.com/rstacruz/git-update-ghpages

ENV['github'] ||= 'nadarei/mina'

namespace :doc do

  task :build do
    cmd = "reacco --literate --toc --github #{ENV['github']}"
    cmd << " --analytics #{ENV['analytics_id']}" if ENV['analytics_id']

    system cmd
    raise "Failed" unless $?.to_i == 0
  end


  desc "Updates online documentation"
  task :deploy => :build do
    system "git update-ghpages #{ENV['github']} -i doc"
  end
end

task :spec do
  system "rm Gemfile.lock; sh -c 'rake=0.8 bundle exec rspec'"
  system "rm Gemfile.lock; sh -c 'rake=0.9 bundle exec rspec'"
end

task :default => :spec
