require 'spec_helper'
require 'command_helper'

describe "Invoking the 'mina' command in a project" do
  before :each do
    Dir.chdir root('test_env')
  end

  it "should think it's 'mina', not 'rake' (1)" do
    run_command 'pinkledills'
    exitstatus.should_not == 0
    stderr.should include 'mina aborted'
  end

  it "should think it's 'mina', not 'rake' (1)" do
    mina '-T'
    stdout.should include 'mina help'
    stdout.should include 'mina git:clone'
  end

  it 'with --version should print the version' do
    mina '--version'
    stdout.should include Mina.version
  end

  it 'with -V should print the version' do
    mina '-V'
    stdout.should include Mina.version
  end

  describe 'without arguments' do
    before :each do
      mina
    end

    it 'should print standard help tasks' do
      mina
      stdout.should include 'mina help'
      stdout.should include 'mina init'
      stdout.should include 'mina tasks'
    end

    it 'should print project-specific tasks' do
      mina
      stdout.should include 'mina deploy'
      stdout.should include 'mina restart'
      stdout.should include 'mina setup'
    end

    it "should be the same as running 'help'" do
      previous_out = stdout

      mina 'help'
      stdout.should == previous_out
    end
  end

  it "with 'mina tasks' should print tasks" do
    mina 'tasks'

    stdout.should include('bundle:install')
    stdout.should include('Install gem dependencies using Bundler')
    stdout.should include('passenger:restart')
  end
end
