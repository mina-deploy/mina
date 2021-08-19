# frozen_string_literal: true

require 'spec_helper'

describe Mina::Runner::Exec do
  subject(:runner) { described_class.new('echo hello') }

  describe '#run' do
    before do
      allow(Kernel).to receive(:exec)
    end

    it 'executes the script' do
      runner.run

      expect(Kernel).to have_received(:exec).with('echo hello')
    end
  end
end
