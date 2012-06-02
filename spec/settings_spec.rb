require 'spec_helper'

describe 'Settings' do
  describe 'instances' do
    before :each do
      @settings = VanHelsing::Settings.new
    end

    it 'setting/getting should work' do
      @settings.host = '192.168.1.1'
      @settings.host.should == '192.168.1.1'
    end

    it 'question mark should work' do
      @settings.deploy_to = '/var/www/there'
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
  end
end

