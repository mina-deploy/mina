require 'spec_helper'

describe 'Mina' do
  it '#to should work' do
    rake {
      task :deploy do
        queue 'git clone'

        to :restart do
          queue 'touch tmp/restart.txt'
        end
      end
    }

    rake { invoke :deploy }

    expect(rake.commands).to eq(['git clone'])
    expect(rake.commands(:restart)).to eq(['touch tmp/restart.txt'])
  end
end
