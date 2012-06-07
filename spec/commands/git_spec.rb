require 'spec_helper'
require 'command_helper'

describe "Invoking the 'mina deploy' command outside of git tree" do
  before do
    temp_path = "/tmp/mina-spec"
    FileUtils.mkdir_p("#{temp_path}/config")
    FileUtils.cp root('spec/fixtures/empty_env/config/deploy.rb'), "#{temp_path}/config/deploy.rb"
    Dir.chdir temp_path
  end

  after do
    FileUtils.rm_rf "/tmp/mina-spec"
    Dir.chdir root
  end

  it 'should prompt empty revision error message' do
    run_command 'deploy', 'simulate=1'
    exitstatus.should_not eq(0)
    stderr.should match(/git revision is empty/i)
  end
end
