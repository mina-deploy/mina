require 'spec_helper'
require 'command_helper'

describe "Invoking the 'vh' command outside a project" do
  before :each do
    Dir.chdir root
  end

  describe "without arguments" do
    before :each do
      vh
    end

    it 'should print standard help tasks' do
      stdout.should include('vh help')
      stdout.should include('vh init')
      stdout.should include('vh tasks')
    end

    it "should not print project-specific tasks" do
      stdout.should_not include('vh deploy')
      stdout.should_not include('vh restart')
      stdout.should_not include('vh setup')
    end

    %w[-h --help].each do |arg|
      it "should have the same output as 'vh #{arg}'" do
        @previous_output = stdout
        vh arg
        stdout.should == @previous_output
      end
    end
  end
end

