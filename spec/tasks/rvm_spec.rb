# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'rvm', type: :rake do
  before do
    load_default_config
  end

  describe 'rvm:use' do
    let(:task_name) { 'rvm:use' }

    context 'without an argument' do
      it 'exits with an error message' do
        expect do
          invoke_all
        end.to raise_error(SystemExit)
           .and output(output_file('rvm_use_without_env')).to_stdout
      end
    end

    context 'with an argument' do
      it 'sets ruby version' do
        expect do
          invoke_all('3.0.0')
        end.to output(output_file('rvm_use_with_env')).to_stdout
      end
    end
  end

  describe 'rvm:wrapper' do
    let(:task_name) { 'rvm:wrapper' }

    context 'without all arguments' do
      it 'exits with an error message' do
        expect do
          invoke_all('ruby-3.0.0')
        end.to raise_error(SystemExit)
           .and output(output_file('rvm_wrapper_without_arguments')).to_stdout
      end
    end

    context 'with all arguments' do
      it 'calls rvm wrapper' do
        expect do
          invoke_all('3.0.0', 'myapp', 'unicorn')
        end.to output(output_file('rvm_wrapper_with_arguments')).to_stdout
      end
    end
  end
end
