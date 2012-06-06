require 'spec_helper'
require 'command_helper'

describe "Invoking the 'mina' command outside a project" do
  before :each do
    Dir.chdir root
  end

  describe "without arguments" do
    before :each do
      mina
    end

    it 'should print standard help tasks' do
      stdout.should include('mina help')
      stdout.should include('mina init')
      stdout.should include('mina tasks')
    end

    it "should not print project-specific tasks" do
      stdout.should_not include('mina deploy')
      stdout.should_not include('mina restart')
      stdout.should_not include('mina setup')
    end

    %w[-h --help].each do |arg|
      it "should have the same output as 'mina #{arg}'" do
        @previous_output = stdout
        mina arg
        stdout.should == @previous_output
      end
    end
  end
end

