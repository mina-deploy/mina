require 'spec_helper'

describe 'Mina' do
  it '#invoke should work' do

    rake {
      task :clone do
        queue 'git clone'
      end
    }

    2.times {
      rake { invoke :clone }
    }

    rake.commands.should == ['git clone']
  end

  it '#invoke should work with :reenable option' do

    rake {
      task :pull do
        queue 'git pull'
      end
    }

    2.times {
      rake { invoke :pull, reenable: true }
    }

    rake.commands.should == ['git pull', 'git pull']
  end
end
