require 'spec_helper'
require 'command_helper'

describe "Invoking the 'vh' command in a project" do
  before :each do
    Dir.chdir root('test_env')
  end

  it 'should echo commands in verbose mode' do
    vh 'deploy', '--verbose', '--simulate'

    stdout.should include "echo \"\\$ git"
  end

  it 'should not echo commands when not in verbose mode' do
    vh 'deploy', '--simulate'

    stdout.should_not include "echo \"\\$ git"
  end
end
