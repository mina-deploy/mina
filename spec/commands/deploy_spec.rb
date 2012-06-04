require 'spec_helper'
require 'command_helper'

describe "Invoking the 'vh' command in a project" do
  before :each do
    Dir.chdir root('test_env')
  end

  describe "to do a simulated deploy" do
    before :each do
      vh 'deploy', 'simulate=1'
    end

    it "should take care of the lockfile" do
      stdout.should =~ /ERROR: another deployment is ongoing/
      stdout.should =~ /touch ".*deploy\.lock"/
      stdout.should =~ /rm -f ".*deploy\.lock"/
    end

    it "should honor releases_path" do
      stdout.should include "releases/"
    end

    it "should symlink the current_path" do
      stdout.should =~ /ln .*current/
    end

    it "should include deploy directives" do
      stdout.should include "bundle exec rake db:migrate"
    end

    it "should include 'to :launch' directives" do
      stdout.should include "touch tmp/restart.txt"
    end
  end
end
