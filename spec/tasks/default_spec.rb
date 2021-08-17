require 'spec_helper'

RSpec.describe 'default', type: :rake do
  describe 'ssh_keyscan_repo' do
    it 'scans ssh' do
      Mina::Configuration.instance.set(:repository, 'git@github.com/exapmle')
      expect { invoke_all }.to output(output_file('ssh_keyscan_repo')).to_stdout
    end
  end

  describe 'run' do
    it 'runs command' do
      subject.invoke('ls -al')
      expect { run_commands.invoke }.to output(output_file('run')).to_stdout
    end

    it 'exits if no command given' do
      expect { subject.invoke }.to raise_error(SystemExit)
                               .and output(/You need to provide a command/).to_stdout
    end
  end

  describe 'ssh' do
    it 'runs ssh when :deploy_to exists' do
      expect_any_instance_of(Kernel).to receive(:exec).with(output_file('ssh'))
      subject.invoke
    end

    it "exits with an error if :deploy_to doesn't exist" do
      deploy_to = Mina::Configuration.instance.remove(:deploy_to)

      expect { subject.invoke }.to raise_error(SystemExit)
                               .and output(/deploy_to must be defined!/).to_stdout

      Mina::Configuration.instance.set(:deploy_to, deploy_to)
    end
  end

  describe 'debug_configuration_variables' do
    it 'prints configrtion variables' do
      Mina::Configuration.instance.set(:debug_configuration_variables, true)
      expect { invoke_all }.to output(/------- Printing current config variables -------/).to_stdout
      Mina::Configuration.instance.remove(:debug_configuration_variables)
    end
  end
end
