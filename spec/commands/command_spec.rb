require 'spec_helper'
require 'command_helper'

describe "Invoking the 'mina' command in a project" do
  before :each do
    Dir.chdir root('test_env')
  end

  it "should think it's 'mina', not 'rake' (1)" do
    run_command 'pinkledills'
    expect(exitstatus).not_to eq(0)
    expect(stderr).to include 'mina aborted'
  end

  it "should think it's 'mina', not 'rake' (1)" do
    mina '-T'
    expect(stdout).to include 'mina help'
    expect(stdout).to include 'mina git:clone'
  end

  it 'with --version should print the version' do
    mina '--version'
    expect(stdout).to include Mina.version
  end

  it 'with -V should print the version' do
    mina '-V'
    expect(stdout).to include Mina.version
  end

  describe 'without arguments' do
    before :each do
      mina
    end

    it 'should print standard help tasks' do
      mina
      expect(stdout).to include 'mina help'
      expect(stdout).to include 'mina init'
      expect(stdout).to include 'mina tasks'
    end

    it 'should print project-specific tasks' do
      mina
      expect(stdout).to include 'mina deploy'
      expect(stdout).to include 'mina restart'
      expect(stdout).to include 'mina setup'
    end

    it "should be the same as running 'help'" do
      previous_out = stdout

      mina 'help'
      expect(stdout).to eq(previous_out)
    end
  end

  it "with 'mina -f' on a non-existing file should fail" do
    run_command '-f', 'foobar'
    expect(stderr).to include 'mina aborted'
    expect(stderr).to include 'No Rakefile found'
  end

  it "with 'mina tasks' should print tasks" do
    mina 'tasks'

    expect(stdout).to include('bundle:install')
    expect(stdout).to include('Install gem dependencies using Bundler')
    expect(stdout).to include('passenger:restart')
  end
end
