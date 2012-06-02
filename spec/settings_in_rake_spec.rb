require 'spec_helper'

describe 'Settings in rake tasks' do
  it '#set should work' do
    rake { set :host, 'localhost' }

    rake.host.should == 'localhost'
    rake.settings.host.should == 'localhost'
  end

  it '#settings ||= should work' do
    rake {
      set :version, '2'
      settings.version ||= '3'
    }

    rake.settings.version.should == '2'
    rake.version.should == '2'
  end

  it '#settings with lambdas should work' do
    rake {
      set :version, '42'
      set :path, lambda { "/var/www/#{version}" }
    }

    rake.path.should == "/var/www/42"
    rake.path?.should be_true
  end
end
