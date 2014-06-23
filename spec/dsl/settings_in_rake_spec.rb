require 'spec_helper'

describe 'Settings in rake tasks' do
  it '#set should work' do
    rake { set :domain, 'localhost' }

    expect(rake.domain).to eql 'localhost'
    expect(rake.settings.domain).to eql 'localhost'
  end

  it '#settings ||= should work' do
    rake {
      set :version, '2'
      settings.version ||= '3'
    }

    expect(rake.settings.version).to eql '2'
    expect(rake.version).to eql '2'
  end

  it '#settings with lambdas should work' do
    rake {
      set :version, '42'
      set :path, lambda { "/var/www/#{version}" }
    }

    expect(rake.path).to eql "/var/www/42"
    expect(rake.path?).to eql true
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
