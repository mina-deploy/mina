require 'spec_helper'
require 'command_helper'

describe "Invoking the 'mina' command in a project without a deploy.rb" do
  before :each do
    Dir.chdir root('spec/fixtures/custom_file_env')
  end

  it 'should fail' do
    run_command 'deploy', '--simulate'
    exitstatus.should > 0
  end

  it 'should pass if you provide a new rakefile' do
    mina 'deploy', '--simulate', '-f', 'custom_deploy.rb'
    stdout.should.include 'Creating a temporary path'
  end
end

