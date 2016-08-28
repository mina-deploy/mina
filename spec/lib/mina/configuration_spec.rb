require 'spec_helper'

describe Mina::Configuration do
  let(:config) { Class.new(Mina::Configuration).instance }
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
  end

  describe '#set?' do
    it 'returns true if key is set' do
      config.set(:key, :value)
      expect(config.set?(:key)).to be true
    end

    it 'returns false if key is not set' do
      expect(config.set?(:key)).to be false
    end
  end

  describe '#ensure!' do
    it 'does not raise error if key is set' do
      config.set(:key, :value)
      expect { config.ensure!(:key) }.to_not raise_error
    end

    it 'raises an error if key is not set' do
      expect { config.ensure!(:key) }.to raise_error(SystemExit)
    end
  end

  describe Mina::Configuration::DSL do
    let(:host_class) { Class.new { include Mina::Configuration::DSL } }
    let(:host) { host_class.new }

    [:fetch, :set].each do |method|
      it "should respond to #{method}" do
        expect(host).to respond_to(method)
      end
    end
  end
end
