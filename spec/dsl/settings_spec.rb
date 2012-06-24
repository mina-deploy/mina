require 'spec_helper'

describe 'Settings' do
  describe 'instances' do
    before :each do
      @settings = Mina::Settings.new
    end

    it 'setting/getting should work' do
      @settings.domain = '192.168.1.1'
      @settings.domain.should == '192.168.1.1'
    end

    it 'question mark should work' do
      @settings.deploy_to = '/var/www/there'
      @settings.deploy_to?.should be_true
      @settings.foobar?.should be_false
    end

    it 'question mark should work with nils' do
      @settings.deploy_to = nil
      @settings.deploy_to?.should be_true
      @settings.foobar?.should be_false
    end

    it '||= should work (1)' do
      @settings.x = 2
      @settings.x ||= 3
      @settings.x.should == 2
    end

    it '||= should work (2)' do
      @settings.x ||= 3
      @settings.x.should == 3
    end

    it 'lambdas should work' do
      @settings.path = lambda { "/var/www/#{@settings.version}" }
      @settings.version = '3'

      @settings.path?.should be_true
      @settings.path.should == "/var/www/3"
    end

    it 'bangs should check for settings' do
      lambda { @settings.non_existent_setting! }.should raise_error(Mina::Error, /non_existent_setting/)
    end

    it 'bangs should return settings' do
      @settings.version = 4
      @settings.version!.should == 4
    end
  end
end

