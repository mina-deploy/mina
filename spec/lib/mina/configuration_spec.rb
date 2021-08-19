# frozen_string_literal: true

require 'spec_helper'

describe Mina::Configuration do
  let(:config) { Class.new(described_class).instance }
  let(:key) { config.fetch(:key, :default) }

  describe '#set' do
    it 'sets by value' do
      config.set(:key, :value)
      expect(key).to eq :value
    end

    it 'sets by block' do
      config.set(:key) { :value }
      expect(key).to eq :value
    end
  end

  describe '#fetch' do
    it 'returns the default value if key not set' do
      expect(key).to eq :default
    end

    it 'returns ENV value if set' do
      ENV['key'] = 'env'
      expect(key).to eq 'env'
      ENV['key'] = nil
    end

    it "returns nil if a default value isn't provided" do
      expect(config.fetch(:key)).to eq(nil)
    end
  end

  describe '#remove' do
    context 'when key exists' do
      before do
        config.set(:key, :value)
      end

      it 'removes the key' do
        expect(config.set?(:key)).to eq(true)

        config.remove(:key)

        expect(config.set?(:key)).to eq(false)
      end

      it 'returns key value' do
        expect(config.remove(:key)).to eq(:value)
      end
    end

    context "when key doesn't exist" do
      it "doesn't do anything" do
        expect(config.set?(:key)).to eq(false)

        config.remove(:key)

        expect(config.set?(:key)).to eq(false)
      end

      it 'returns nil' do
        expect(config.remove(:key)).to eq(nil)
      end
    end
  end

  describe '#set?' do
    it 'returns true if key is set' do
      config.set(:key, :value)
      expect(config.set?(:key)).to be true
    end

    it 'returns false if key is set with nil value' do
      config.set(:key, nil)
      expect(config.set?(:key)).to be false
    end

    it 'returns false if key is not set' do
      expect(config.set?(:key)).to be false
    end
  end

  describe '#ensure!' do
    it 'does not raise error if key is set' do
      config.set(:key, :value)
      expect { config.ensure!(:key) }.not_to raise_error
    end

    it 'raises an error if key is not set' do
      expect { config.ensure!(:key) }.to raise_error(SystemExit)
                                     .and output(/key must be defined!/).to_stdout
    end
  end

  describe '#reset!' do
    before do
      config.set(:key, :value)
    end

    it 'cleans all variables' do
      expect(config.variables).not_to be_empty

      config.reset!

      expect(config.variables).to be_empty
    end
  end

  describe Mina::Configuration::DSL do
    let(:host_class) { Class.new { include Mina::Configuration::DSL } }
    let(:host) { host_class.new }

    [:fetch, :set].each do |method|
      it "responds to #{method}" do
        expect(host).to respond_to(method)
      end
    end
  end
end
