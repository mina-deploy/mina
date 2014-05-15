require 'spec_helper'
require 'command_helper'

describe "Invoking the 'mina' command in a project without a deploy.rb" do
  before :each do
    Dir.chdir root('spec/fixtures/custom_file_env')
    FileUtils.rm_rf 'deploy'
  end

  it 'should fail' do
    run_command 'deploy', '--simulate'
    expect(exitstatus).to be > 0
  end

  it 'should pass if you provide a new rakefile' do
    mina 'deploy', '--simulate', '-f', 'custom_deploy.rb'
    expect(stdout).to include 'Creating a temporary build path'
  end
end

