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
      expect(stdout).to include('mina help')
      expect(stdout).to include('mina init')
      expect(stdout).to include('mina tasks')
    end

    it "should not print project-specific tasks" do
      expect(stdout).not_to include('mina deploy')
      expect(stdout).not_to include('mina restart')
      expect(stdout).not_to include('mina setup')
    end

    %w[-h --help].each do |arg|
      it "should have the same output as 'mina #{arg}'" do
        @previous_output = stdout
        mina arg
        expect(stdout).to eq(@previous_output)
      end
    end
  end
end

