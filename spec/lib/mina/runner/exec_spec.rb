require 'spec_helper'

describe Mina::Runner::Exec do
  subject(:runner) { described_class.new('echo hello') }

  describe '#run' do
    before do
      allow(Kernel).to receive(:exec)
      expect_any_instance_of(Kernel).to receive(:exec).with('echo hello')
    end

    it 'executes the script' do
      runner.run
    end
  end
end
