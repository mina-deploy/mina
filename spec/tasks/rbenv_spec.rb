require 'spec_helper'

RSpec.describe 'rbenv', type: :rake do
  describe 'rbenv:load' do
    it 'loads rbenv' do
      expect { invoke_all }.to output(output_file('rbenv_load')).to_stdout
    end
  end
end
