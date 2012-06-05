# Do these:
#
#     *do `gem install reacco`
#     * install http://github.com/rstacruz/git-update-ghpages

ENV['github'] ||= 'nadarei/van_helsing'

namespace :doc do

  task :build do
    cmd = "reacco --literate --toc --github #{ENV['github']}"
    cmd << " --analytics=#{ENV['analytics_id']}" if ENV['analytics_id']

    system cmd
    raise "Failed" unless $?.to_i == 0
  end


  desc "Updates online documentation"
  task :deploy => :build do
    system "git update-ghpages #{ENV['github']} -i doc"
  end
end

task :spec do
  ENV['rake'] = '0.8'; system "rspecx"
  raise "Rspec failed" if $?.to_i != 0
  ENV['rake'] = '0.9'; system "rspec"
  raise "Rspec failed" if $?.to_i != 0
end

task :'spec:verbose' do
  system "rspec --format documentation"
  system "rspec --format documentation"
end

task :default => :spec
