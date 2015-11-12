require 'spec_helper'

describe 'Mina' do
  it '#to should work' do
    rake {
      task :deploy do
        queue 'git clone'

        to :restart do
          in_directory 'tmp' do
            queue 'touch restart.txt'
          end
        end
      end
    }

    rake { invoke :deploy }

    expect(rake.commands).to eq(['git clone'])
    expect(rake.commands(:restart)).to eq(['(cd tmp && (touch restart.txt))'])
  end
end
