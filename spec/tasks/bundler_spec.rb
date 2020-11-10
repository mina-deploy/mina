require 'spec_helper'

RSpec.describe 'bundler', type: :rake do
  context 'version 2' do
    before(:each) { Mina::Configuration.instance.set(:bundle_version, 2) }

    describe 'bundle:install' do
      it 'bundle install' do
        expect { invoke_all }.to output(output_file('bundle_install_2')).to_stdout
      end
    end

    describe 'bundle:clean' do
      it 'bundle clean' do
        expect { invoke_all }.to output(output_file('bundle_clean')).to_stdout
      end
    end
  end

  context 'version 1' do
    before(:each) { Mina::Configuration.instance.set(:bundle_version, 1) }

    describe 'bundle:install' do
      it 'bundle install' do
        expect { invoke_all }.to output(output_file('bundle_install_1')).to_stdout
      end
    end

    describe 'bundle:clean' do
      it 'bundle clean' do
        expect { invoke_all }.to output(output_file('bundle_clean')).to_stdout
      end
    end
  end
end
