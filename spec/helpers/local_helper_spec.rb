require 'spec_helper'

describe Mina::LocalHelpers::Local do
  describe '.invoke' do
    let :scope do
      double("rake_application").tap do |scope|
        allow(scope).to receive(:settings).and_return(settings)
      end
    end

    let(:settings) { OpenStruct.new }

    it 'uses the pretty system with shell-escaped command when term_mode is set to :pretty and pretty is supported' do
      settings.term_mode = :pretty
      cmd = %[echo "hello"]

      allow(described_class).to receive(:pretty_supported?).and_return(true)
      expect(scope).to receive(:pretty_system).with(Shellwords.escape(cmd)).and_return(0)

      described_class.invoke(cmd, scope)
    end

    it 'does NOT use the pretty system when term_mode is set to :pretty and pretty is NOT supported' do
      settings.term_mode = :pretty
      cmd = %[echo "hello"]

      allow(described_class).to receive(:pretty_supported?).and_return(false)
      expect(scope).not_to receive(:pretty_system)
      expect(Kernel).to receive(:exec).and_return(0)

      described_class.invoke(cmd, scope)
    end

    it 'returns the sub-shell exit status when using the pretty system' do
      settings.term_mode = :pretty

      allow(described_class).to receive(:pretty_supported?).and_return(true)
      allow(scope).to receive(:pretty_system).with("return0").and_return(0)
      allow(scope).to receive(:pretty_system).with("return13").and_return(13)

      expect(described_class.invoke("return0", scope)).to eq 0
      expect(described_class.invoke("return13", scope)).to eq 13
    end

    it 'calls Kernel.exec with non shell-escaped command when term_mode is :exec' do
      settings.term_mode = :exec
      cmd = %[echo "hello"]

      expect(Kernel).to receive(:exec).with(cmd).and_return(0)

      described_class.invoke(cmd, scope)
    end

    it 'calls Kernel.system with non shell-escaped command when term_mode is not :pretty nor :exec' do
      settings.term_mode = nil
      cmd = %[echo "hello"]

      expect(Kernel).to receive(:system).with(cmd).and_return("hello\n")

      described_class.invoke(cmd, scope)
    end

    it 'returns the sub-shell exit status when using Kernel.system' do
      settings.term_mode = nil

      expect(described_class.invoke(%[/bin/sh -c 'exit 0'], scope)).to eq 0
      expect(described_class.invoke(%[/bin/sh -c 'exit 13'], scope)).to eq 13
    end
  end
end
