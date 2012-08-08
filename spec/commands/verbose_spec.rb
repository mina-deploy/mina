require 'spec_helper'
require 'command_helper'

describe "Invoking the 'mina' command in a project" do
  before :each do
    Dir.chdir root('test_env')
  end

  it 'should echo commands in verbose mode' do
    mina 'deploy', '--verbose', '--simulate'

    stdout.should include %[echo #{Shellwords.escape('$ git')}]
  end

  it 'should not echo commands when not in verbose mode' do
    mina 'deploy', '--simulate'

    stdout.should_not include %[echo #{Shellwords.escape('$ git')}]
  end
end
