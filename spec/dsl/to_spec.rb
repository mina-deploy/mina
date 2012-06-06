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

    rake.commands.should == ['git clone']
    rake.commands(:restart).should == ['touch tmp/restart.txt']
  end
end
