require 'spec_helper'
require 'command_helper'
require 'fileutils'
require 'tmpdir'

describe "Invoking the 'vh' command in a project", :ssh => true do
  before :each do
    @path = Dir.mktmpdir
    Dir.chdir @path

    FileUtils.mkdir_p './config'
    FileUtils.cp root('test_env/config/deploy.rb'), './config/deploy.rb'
    FileUtils.rm_rf './deploy'
    FileUtils.mkdir_p './deploy'
  end

  after :each do
    FileUtils.rm_rf @path
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
    File.exists?('deploy/releases/1/README.md').should be_true
    File.directory?('deploy/releases/2').should be_false
    File.exists?('deploy/current').should be_true
    File.read('deploy/last_version').strip.should == '1'
    File.exists?('deploy/current/tmp/restart.txt').should be_true

    # And again
    print "[deploy 2]" if ENV['verbose']
    vh 'deploy', '--verbose'
    File.directory?('deploy/releases/2').should be_true
    File.read('deploy/last_version').strip.should == '2'
  end
end
