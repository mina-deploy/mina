require 'spec_helper'
require 'command_helper'
require 'fileutils'

describe "Invoking the 'vh' command in a project", :ssh => true do
  before :each do
    Dir.chdir root('test_env')
    FileUtils.rm_rf './deploy'
    FileUtils.mkdir_p './deploy'
  end

  it 'should set up and deploy fine' do
    print "[setup]" if ENV['verbose']
    vh 'setup', '--verbose'
    File.directory?('deploy').should be_true
    File.directory?('deploy/releases').should be_true
    File.directory?('deploy/shared').should be_true
    File.exists?('deploy/last_version').should be_false
    File.exists?('deploy/deploy.lock').should be_false

    print "[deploy 1]" if ENV['verbose']
    vh 'deploy', '--verbose'
    File.exists?('deploy/last_version').should be_true
    File.exists?('deploy/deploy.lock').should be_false
    File.directory?('deploy/releases').should be_true
    File.directory?('deploy/releases/1').should be_true
    File.directory?('deploy/releases/2').should be_false
    File.exists?('deploy/current').should be_true
    File.read('deploy/last_version').strip.should == '1'

    # And again
    print "[deploy 2]" if ENV['verbose']
    vh 'deploy', '--verbose'
    File.directory?('deploy/releases/2').should be_true
    File.read('deploy/last_version').strip.should == '2'
  end
end
