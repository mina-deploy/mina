require 'spec_helper'

RSpec.describe 'ruby_managers', type: :rake do
  describe 'ry' do
    it 'ry' do
      expect { invoke_all }.to output(output_file('ry')).to_stdout
    end
  end

  describe 'rbenv:load' do
    it 'rbenv:load' do
      expect { invoke_all }.to output(output_file('rbenv_load')).to_stdout
    end
  end

  describe 'chruby' do
    it 'chruby' do
      expect { invoke_all('123') }.to output(output_file('chruby')).to_stdout
    end
  end

  describe 'rvm:use' do
    it 'rvm:use' do
      expect { invoke_all('123') }.to output(output_file('rvm_use')).to_stdout
    end
  end

  # describe 'rvm:wrapper' do
  #   it 'rails db migrate' do
  #     expect { invoke_all('123') }.to output('').to_stdout
  #   end
  # end
end
