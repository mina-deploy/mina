# frozen_string_literal: true

require 'spec_helper'

describe Mina::Runner do
  let(:instance) { Mina::Configuration.instance }

  describe '#initialize' do
    it 'raises an error if execution mode is not set' do
      instance.remove(:execution_mode)
      expect { described_class.new(nil, nil) }.to raise_error('You must specify execution mode')
    end

    it 'sets execution mode to printer if simulate is true' do
      instance.set(:execution_mode, :pretty)
      instance.set(:simulate, true)
      expect(described_class.new(nil, nil).execution_mode).to eq(:printer)
      instance.remove(:simulate)
    end
  end

  describe '#run' do
    it 'runs the commands on a backend' do
      instance.set(:execution_mode, :printer)
      runner = described_class.new(['ls -al'], :local)

      if Mina::OS.windows?
        expect { runner.run }.to output("ls -al\n").to_stdout
      else
        expect { runner.run }.to output("\\[\\\"ls\\ -al\\\"\\]\n").to_stdout
      end
    end
  end
end
