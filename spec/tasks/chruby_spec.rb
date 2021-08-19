require 'spec_helper'

RSpec.describe 'chruby', type: :rake do
  before do
    load_default_config
  end

  describe 'chruby' do
    subject { rake['chruby'] }

    context 'without an argument' do
      it 'exits with an error message' do
        expect do
          invoke_all
        end.to raise_error(SystemExit).and output(output_file('chruby_without_env')).to_stdout
      end
    end

    context 'with an argument' do
      it 'sets ruby version' do
        expect do
          invoke_all('123')
        end.to output(output_file('chruby_with_env')).to_stdout
      end
    end
  end
end
