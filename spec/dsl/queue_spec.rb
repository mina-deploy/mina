require 'spec_helper'

describe 'Mina' do
  it '#invoke should work' do
    rake {
      task :hello do
        @hello = 'world'
      end
      invoke :hello
    }
    rake.instance_variable_get(:@hello).should == 'world'
  end

  it '#queue should work' do
    rake {
      queue 'sudo service nginx restart'
    }

    rake.commands.should == ['sudo service nginx restart']
  end

  it '#queue should work with multiple commands' do
    rake {
      queue 'echo Restarting'
      queue 'sudo service nginx restart'
    }

    rake.commands.should == ['echo Restarting', 'sudo service nginx restart']
  end

  it '#queue should work inside tasks' do
    rake {
      task :restart do
        queue 'echo Restarting'
        invoke :'passenger:restart'
      end

      namespace :passenger do
        task :restart do
          queue 'touch tmp/restart.txt'
        end
      end
    }

    rake { invoke :restart }

    rake.commands.should == ['echo Restarting', 'touch tmp/restart.txt']
  end
end
