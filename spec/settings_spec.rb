require 'spec_helper'

describe 'Van Helsing' do
  it '#settings should work' do
    rake {
      set :host, 'localhost'
    }

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
end
