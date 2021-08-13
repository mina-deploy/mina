require 'spec_helper'

describe Mina::Runner::Pretty do
  subject(:runner) { described_class.new('true') }

  describe '#run', :suppressed_output do
    it 'executes the script' do
      expect { runner.run }.to output('').to_stdout
    end

    it 'returns true', :suppressed_output do
      expect(runner.run).to eq(true)
    end
  end
end
