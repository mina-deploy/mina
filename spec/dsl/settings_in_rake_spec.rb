require 'spec_helper'

describe 'Settings in rake tasks' do
  it '#set should work' do
    rake { set :domain, 'localhost' }

    expect(rake.domain).to eq('localhost')
    expect(rake.settings.domain).to eq('localhost')
  end

  it '#settings ||= should work' do
    rake {
      set :version, '2'
      settings.version ||= '3'
    }

    expect(rake.settings.version).to eq('2')
    expect(rake.version).to eq('2')
  end

  it '#settings with lambdas should work' do
    rake {
      set :version, '42'
      set :path, lambda { "/var/www/#{version}" }
    }

    expect(rake.path).to eq("/var/www/42")
    expect(rake.path?).to be_truthy
  end

  it '#settings with a bang should work' do
    expect {
      rake {
        set :path, lambda { "/var/www/#{version!}" }
      }
      rake.path
    }.to raise_error(Mina::Error, /version/)
  end
end
