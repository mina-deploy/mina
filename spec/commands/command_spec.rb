require 'spec_helper'
require 'command_helper'

describe "Invoking the 'vh' command in a project" do
  before :each do
    Dir.chdir root('test_env')
  end

  it 'with --version should print the version' do
    vh '--version'
    stdout.should include VanHelsing.version
  end

  it 'with -V should print the version' do
    vh '-V'
    stdout.should include VanHelsing.version
  end

  describe 'without arguments' do
    before :each do
      vh
    end

    it 'should print standard help tasks' do
      vh
      stdout.should include 'vh help'
      stdout.should include 'vh init'
      stdout.should include 'vh tasks'
    end

    it 'should print project-specific tasks' do
      vh
      stdout.should include 'vh deploy'
      stdout.should include 'vh restart'
      stdout.should include 'vh setup'
    end

    it "should be the same as running 'help'" do
      previous_out = stdout

      vh 'help'
      stdout.should == previous_out
    end
  end

  it "with 'vh tasks' should print tasks" do
    vh 'tasks'

    stdout.should include('bundle:install')
    stdout.should include('Install gem dependencies using Bundler')

    stdout.should include('rails:assets_precompile')
    stdout.should include('nginx:restart')
  end
end
