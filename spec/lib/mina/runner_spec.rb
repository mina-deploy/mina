require 'spec_helper'

describe Mina::Runner do
  let(:instance) { Mina::Configuration.instance }

  describe '#initialize' do
    it 'raises an error if execution mode is not set' do
      instance.remove(:execution_mode)
      expect { Mina::Runner.new(nil, nil) }.to raise_error('You must specify execution mode')
    end

    it 'raises an error when run on windows and pretty print' do
      instance.set(:execution_mode, :pretty)
      allow(Gem::Platform.local).to receive(:os).and_return(:windows)
      expect { Mina::Runner.new(nil, nil) }.to raise_error('Unsuported execution mode (pretty on windows)')
    end

    it 'sets execution mode to printer if simulate is true' do
      instance.set(:execution_mode, :pretty)
      instance.set(:simulate, :true)
      expect(Mina::Runner.new(nil, nil).execution_mode).to eq(:printer)
      instance.remove(:simulate)
    end
  end

  describe '#run' do
    it 'runs the commands on a backend' do
      instance.set(:execution_mode, :printer)
      runner = Mina::Runner.new(['ls -al'], :local)
      expect { runner.run }.to output("\\[\\\"ls\\ -al\\\"\\]\n").to_stdout
    end
  end
end
