require 'spec_helper'
require 'command_helper'

describe 'Command' do
  describe 'outside a project' do
    before :each do
      Dir.chdir root
    end

    it 'should print help' do
      vh
      exitstatus.should == 0
      stdout.should include('vh help')
      stdout.should include('vh init')
      stdout.should include('vh tasks')
      stdout.should_not include('vh deploy')
      stdout.should_not include('vh restart')
      stdout.should_not include('vh setup')
    end
  end

  describe 'in a project' do
    before :each do
      Dir.chdir root('test_env')
    end

    it 'should print help' do
      vh

      exitstatus.should == 0
      stdout.should include('vh help')
      stdout.should include('vh init')
      stdout.should include('vh tasks')
      stdout.should include('vh deploy')
      stdout.should include('vh restart')
      stdout.should include('vh setup')
    end

    it 'should run help when ran without arguments' do
      vh
      previous_out = stdout

      vh 'help'
      exitstatus.should == 0
      stdout.should == previous_out
    end

    it "'vh tasks' should print tasks" do
      vh 'tasks'
      exitstatus.should == 0
      stdout.should include('bundle:install')
      stdout.should include('Install gem dependencies using Bundler')

      stdout.should include('rails:assets_precompile')
      stdout.should include('nginx:restart')
    end

    describe "a simulated deploy" do
      before :each do
        vh *%w[deploy simulate=1]
        exitstatus.should == 0
      end
      
      it "should include some stuff" do
        stdout.should include("#{Dir.pwd}/releases")
        stdout.should include("releases/#{Time.now.strftime('%Y-%m-%d')}")
        stdout.should =~ /rm -f ".*deploy.lock"/
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
end
