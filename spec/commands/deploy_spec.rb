require 'spec_helper'
require 'command_helper'

describe "Invoking the 'mina' command in a project" do
  before :each do
    Dir.chdir root('test_env')
  end

  describe "to do a simulated deploy" do
    before :each do
      mina 'deploy', 'simulate=1'
    end

    it "should take care of the lockfile" do
      expect(stdout).to match(/ERROR: another deployment is ongoing/)
      expect(stdout).to match(/touch ".*deploy\.lock"/)
      expect(stdout).to match(/rm -f ".*deploy\.lock"/)
    end

    it "should honor releases_path" do
      expect(stdout).to include "releases/"
    end

    it "should symlink the current_path" do
      expect(stdout).to match(/ln .*current/)
    end

    it "should include deploy directives" do
      expect(stdout).to include "bundle exec rake db:migrate"
    end

    it "should include 'to :build' directives" do
      stdout.should include "touch build.txt"
    end

    it "should include 'to :launch' directives" do
      expect(stdout).to include "touch tmp/restart.txt"
    end
  end
end
