require 'spec_helper'

describe 'Mina' do
  it '#invoke should work' do
    rake {
      task :hello do
        @hello = 'world'
      end
      invoke :hello
    }
    expect(rake.instance_variable_get(:@hello)).to eq('world')
  end

  it '#queue should work' do
    rake {
      queue 'sudo service nginx restart'
    }

    expect(rake.commands).to eq(['sudo service nginx restart'])
  end

  it '#queue should work with multiple commands' do
    rake {
      queue 'echo Restarting'
      queue 'sudo service nginx restart'
    }

    expect(rake.commands).to eq(['echo Restarting', 'sudo service nginx restart'])
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

    expect(rake.commands).to eq(['echo Restarting', 'touch tmp/restart.txt'])
  end
end
