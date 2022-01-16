# frozen_string_literal: true

require 'spec_helper'

describe Mina::Backend::Local do
  let(:backend) { described_class.new('ls -al') }

  describe '#prepare' do
    it 'escpaces shellwords' do
      Mina::Configuration.instance.remove(:simulate)

      if Mina::OS.windows?
        expect(backend.prepare).to eq('"ls -al"')
      else
        expect(backend.prepare).to eq('ls\\ -al')
      end
    end

    it 'adds debug if simualte' do
      Mina::Configuration.instance.set(:simulate, true)
      expect(backend.prepare).to eq("#!/usr/bin/env bash\n# Executing the following:\n#\nls -al\n ")
      Mina::Configuration.instance.remove(:simulate)
    end
  end
end
