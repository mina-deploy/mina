require 'spec_helper'

RSpec.describe 'bundler', type: :rake do
  describe 'bundle:install' do
    it 'bundle install' do
      expect { invoke_all }.to output(output_file('bundle_install')).to_stdout
    end
  end

  describe 'bundle:clean' do
    it 'bundle clean' do
      expect { invoke_all }.to output(output_file('bundle_clean')).to_stdout
    end
  end
end
