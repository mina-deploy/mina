require 'spec_helper'

describe 'Settings' do
  describe 'instances' do
    before :each do
      @settings = Mina::Settings.new
    end

    it 'setting/getting should work' do
      @settings.domain = '192.168.1.1'

      expect(@settings.domain).to eq('192.168.1.1')
    end

    it 'question mark should work' do
      @settings.deploy_to = '/var/www/there'

      expect(@settings.deploy_to?).to be_truthy
      expect(@settings.foobar?).to be_falsey
    end

    it 'question mark should work with nils' do
      @settings.deploy_to = nil

      expect(@settings.deploy_to?).to be_truthy
      expect(@settings.foobar?).to be_falsey
    end

    it '||= should work (1)' do
      @settings.x = 2
      @settings.x ||= 3

      expect(@settings.x).to eq(2)
    end

    it '||= should work (2)' do
      @settings.x ||= 3

      expect(@settings.x).to eq(3)
    end

    it 'lambdas should work' do
      @settings.path = lambda { "/var/www/#{@settings.version}" }
      @settings.version = '3'

      expect(@settings.path?).to be_truthy
      expect(@settings.path).to eq("/var/www/3")
    end

    it 'bangs should check for settings' do
      expect { @settings.non_existent_setting! }.to raise_error(Mina::Error, /non_existent_setting/)
    end

    it 'bangs should return settings' do
      @settings.version = 4

      expect(@settings.version!).to eq(4)
    end
  end
end

