require 'spec_helper'

describe 'Mina' do
  it '#invoke should work' do
    rake do
      task :clone do
        queue 'git clone'
      end
    end

    expect(rake.commands).to eq(['git clone'])
  end

  it '#invoke with task arguments should work with :reenable option' do
    rake do
      task :hello, [:world] do |_, args|
        queue "echo Hello #{args[:world]}"
      end
    end

    %w(World Pirate).each do |name|
      rake { invoke :"hello[#{name}]" }
    end

    expect(rake.commands).to eq(['echo Hello World', 'echo Hello Pirate'])
  end
end
