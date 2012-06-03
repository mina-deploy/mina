require 'spec_helper'
require 'command_helper'

describe "Invoking the 'vh' command in a project" do
  before :each do
    Dir.chdir root('test_env')
  end

  describe 'without arguments' do
    before :each do
      vh
    end
    it 'should print standard help tasks' do
      vh
      stdout.should include('vh help')
      stdout.should include('vh init')
      stdout.should include('vh tasks')
    end

    it 'should print project-specific tasks' do
      vh
      stdout.should include('vh deploy')
      stdout.should include('vh restart')
      stdout.should include('vh setup')
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

  describe "to do a simulated deploy" do
    before :each do
      vh 'deploy', 'simulate=1'
    end
    
    it "take care of the lockfile" do
      # Lockfile sanity check
      stdout.should include "another deployment is ongoing"
      stdout.should =~ /touch ".*deploy\.lock"/
        stdout.should =~ /rm -f ".*deploy\.lock"/
    end

    it "should honor release_path" do
      stdout.should include "#{Dir.pwd}/releases"
      stdout.should =~ /cd ".*releases\/#{Time.now.strftime('%Y-%m-%d')}/
    end

    it "should include deploy directives" do
      # The recipes should be there
      stdout.should include "bundle exec rake db:migrate"
    end

    it "should include 'to :restart' directives" do
      # The recipes should be there
      stdout.should include "sudo /opt/sbin/nginx -s reload"
    end
  end
end
