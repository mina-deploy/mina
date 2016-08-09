require 'spec_helper'

describe Mina::Helpers::Internal do
  class DummyInternalHelper
    include Mina::DSL
    include Mina::Helpers::Internal
  end

  let(:helper) { DummyInternalHelper.new }

  describe '#deploy_script' do
    before do
      Mina::Configuration.instance.set(:deploy_script, 'data/deploy.sh.erb')
      Mina::Configuration.instance.set(:version_scheme, :sequence)
    end

    it 'returns whole script' do
      expect(helper.deploy_script {}).to_not be_empty
    end
  end

  describe '#erb' do
    before { Mina::Configuration.instance.set(:version_scheme, :sequence) }
    after { Mina::Configuration.instance.remove(:version_scheme) }

    it 'returns whole script' do
      expect(helper.erb('data/deploy.sh.erb')).to_not be_empty
    end
  end

  describe '#echo_cmd' do
    context 'when not verbose' do
      it 'reuturns unedited code' do
        expect(helper.echo_cmd('ls -al')).to eq('ls -al')
      end
    end

    context 'when verbose' do
      before { Mina::Configuration.instance.set(:verbose, true) }
      after { Mina::Configuration.instance.remove(:verbose) }

      it 'modifies code' do
        expect(helper.echo_cmd('ls -al')).to eq("echo \\$\\ ls\\ -al &&\nls -al")
      end

      it 'does not modify code if ignore_verbose is true' do
        expect(helper.echo_cmd('ls -al', ignore_verbose: true)).to eq('ls -al')
      end
    end
  end

  describe '#indent' do
    it 'indents code' do
      expect(helper.indent(4, 'ls -al')).to eq('    ls -al')
    end
  end
end
