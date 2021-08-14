require 'spec_helper'

RSpec.describe 'ry', type: :rake do
  describe 'ry' do
    subject { rake['ry'] }

    let(:default_version_warning) { /Task 'ry' without argument will use default Ruby version\./ }

    context 'without an argument' do
      it 'prints a warning' do
        expect do
          invoke_all
        end.to output(default_version_warning).to_stdout
      end

      it 'sets ruby version' do
        expect do
          invoke_all
        end.to output(output_file('ry_without_env')).to_stdout
      end
    end

    context 'with an argument' do
      it "doesn't print a warning" do
        expect do
          invoke_all('3.0.0')
        end.not_to output(default_version_warning).to_stdout
      end
    end

    it 'sets ruby version' do
      expect do
        invoke_all('3.0.0')
      end.to output(output_file('ry_with_env')).to_stdout
    end
  end
end
