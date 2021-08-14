require 'spec_helper'

RSpec.describe 'default', type: :rake do
  describe 'environment' do
    it 'outputs a deprecation warning' do
      expect { invoke_all }.to output(output_file('environment')).to_stdout
    end
  end

  describe 'ssh_keyscan_repo' do
    it 'scans ssh' do
      Mina::Configuration.instance.set(:repository, 'git@github.com/exapmle')
      expect { invoke_all }.to output(output_file('ssh_keyscan_repo')).to_stdout
    end
  end

  describe 'ssh_keyscan_domain' do
    subject { rake['ssh_keyscan_domain'] }

    context "when domain isn't set" do
      around do |example|
        original_domain = Mina::Configuration.instance.fetch(:domain)
        Mina::Configuration.instance.remove(:domain)
        example.run
        Mina::Configuration.instance.set(:domain, original_domain)
      end

      it 'exits with an error message' do
        expect do
          invoke_all
        end.to raise_error(SystemExit)
           .and output(/domain must be defined!/).to_stdout
      end
    end

    context "when port isn't set" do
      around do |example|
        original_port = Mina::Configuration.instance.fetch(:port)
        Mina::Configuration.instance.remove(:port)
        example.run
        Mina::Configuration.instance.set(:port, original_port)
      end

      it 'exits with an error message' do
        expect do
          invoke_all
        end.to raise_error(SystemExit)
           .and output(/port must be defined!/).to_stdout
      end
    end

    context 'when conditions are met' do
      it 'scans ssh' do
        expect do
          invoke_all
        end.to output(output_file('ssh_keyscan_domain')).to_stdout
      end
    end
  end

  describe 'run' do
    it 'runs command' do
      subject.invoke('ls -al')
      expect { run_commands.invoke }.to output(output_file('run')).to_stdout
    end

    it 'exits if no command given' do
      expect { subject.invoke }.to raise_error(SystemExit)
    end
  end

  describe 'ssh' do
    it 'runs ssh' do
      expect_any_instance_of(Kernel).to receive(:exec)
      subject.invoke
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
