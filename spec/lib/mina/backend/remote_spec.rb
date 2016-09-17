require 'spec_helper'

describe Mina::Backend::Remote do
  let(:backend) { Mina::Backend::Remote.new ['ls -al'] }
  before { Mina::Configuration.instance.set(:domain, 'localhost') }
  after { Mina::Configuration.instance.remove(:domain) }

  describe '#prepare' do
    it 'escpaces shellwords' do
      expect(backend.prepare).to eq("ssh localhost -p 22 -tt -- \\[\\\"ls\\ -al\\\"\\]")
    end

    it 'adds debug if simualte' do
      Mina::Configuration.instance.set(:simulate, true)
      expect(backend.prepare).to eq("#!/usr/bin/env bash\n# Executing the following via 'ssh localhost -p 22 -tt':\n#\nls -al\n ")
      Mina::Configuration.instance.remove(:simulate)
    end
  end
end
