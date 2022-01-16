# frozen_string_literal: true

require 'spec_helper'

describe Mina::Helpers::Internal do
  let(:dummy_class) do
    Class.new do
      include Mina::DSL
      include Mina::Helpers::Internal
    end
  end
  let(:helper) { dummy_class.new }

  describe '#deploy_script' do
    before do
      Mina::Configuration.instance.set(:deploy_script, Mina.root_path('data/deploy.sh.erb'))
      Mina::Configuration.instance.set(:version_scheme, :sequence)
    end

    it 'returns whole script' do
      expect(helper.deploy_script {}).not_to be_empty
    end
  end

  describe '#erb' do
    before { Mina::Configuration.instance.set(:version_scheme, :sequence) }

    it 'returns whole script' do
      expect(helper.erb('data/deploy.sh.erb')).not_to be_empty
    end
  end

  describe '#echo_cmd' do
    context 'when not verbose' do
      before { Mina::Configuration.instance.set(:verbose, false) }

      it 'returns unedited code' do
        expect(helper.echo_cmd('ls -al')).to eq('ls -al')
      end
    end

    context 'when verbose' do
      before { Mina::Configuration.instance.set(:verbose, true) }

      it 'modifies code' do
        if Mina::OS.windows?
          expect(helper.echo_cmd('ls -al')).to eq("echo \"$ ls -al\" &&\nls -al")
        else
          expect(helper.echo_cmd('ls -al')).to eq("echo \\$\\ ls\\ -al &&\nls -al")
        end
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

  describe '#unindent' do
    it 'unindents code' do
      expect(helper.unindent("    ls -al\n")).to eq('ls -al')
    end
  end

  describe '#report_time' do
    context 'when :skip_report_time is true' do
      before { Mina::Configuration.instance.set(:skip_report_time, true) }

      it "doesn't output report time" do
        expect do
          helper.report_time {}
        end.not_to output.to_stdout
      end
    end

    context 'when :skip_report_time is false' do
      before { Mina::Configuration.instance.set(:skip_report_time, false) }

      it 'outputs report time' do
        expect do
          helper.report_time {}
        end.to output(/Elapsed time: \d+\.\d\d seconds/).to_stdout
      end
    end
  end

  describe '#next_version' do
    before do
      Mina::Configuration.instance.set(:releases_path, '/releases')
    end

    context 'when :version_scheme is :datetime' do
      before do
        Mina::Configuration.instance.set(:version_scheme, :datetime)

        allow(Time).to receive(:now).and_return(Time.parse('2020-05-01 12:34:56 UTC'))
      end

      after { Mina::Configuration.instance.remove(:version_scheme) }

      it 'formats current UTC time' do
        expect(helper.next_version).to eq('20200501123456')
      end
    end

    context 'when :version_scheme is :sequence' do
      before { Mina::Configuration.instance.set(:version_scheme, :sequence) }

      it 'generates a command to calculate the next version' do
        expect(helper.next_version).to eq('$((`ls -1 /releases | sort -n | tail -n 1`+1))')
      end
    end

    context 'when :version_scheme is unknown' do
      before { Mina::Configuration.instance.set(:version_scheme, :foobar) }

      it 'exits with an error message' do
        expect do
          helper.next_version
        end.to raise_error(SystemExit)
           .and output(/Unrecognized version scheme\. Use :datetime or :sequence/).to_stdout
      end
    end
  end

  describe '#error!' do
    it 'exits with an error message' do
      expect do
        helper.error!('foobar')
      end.to raise_error(SystemExit).and output(/foobar/).to_stdout
    end
  end
end
