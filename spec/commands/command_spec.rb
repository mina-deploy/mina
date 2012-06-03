require 'spec_helper'
require 'command_helper'

describe "Invoking the 'vh' command in a project" do
  before :each do
    Dir.chdir root('test_env')
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

  it 'should run help when ran without arguments' do
    vh
    previous_out = stdout

    vh 'help'
    stdout.should == previous_out
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
