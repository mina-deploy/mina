# frozen_string_literal: true

require 'spec_helper'

describe Mina::Runner::Printer do
  subject(:runner) { described_class.new('echo hello') }

  describe '#run' do
    it 'prints the script to stdout' do
      expect do
        runner.run
      end.to output("echo hello\n").to_stdout
    end

    it 'returns true', :suppressed_output do
      expect(runner.run).to eq(true)
    end
  end
end
