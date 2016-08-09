require 'spec_helper'

RSpec.describe 'rails', type: :rake do
  describe 'console' do
    it 'starts console' do
      expect { invoke_all }.to output(output_file('console')).to_stdout
    end
  end

  describe 'log' do
    it 'tails log' do
      expect { invoke_all }.to output(output_file('log')).to_stdout
    end
  end

  describe 'rails:db_migrate' do
    it 'rails db migrate' do
      expect { invoke_all }.to output(output_file('rails_db_migrate')).to_stdout
    end
  end

  describe 'rails:db_create' do
    it 'rails db create' do
      expect { invoke_all }.to output(output_file('rails_db_create')).to_stdout
    end
  end

  describe 'rails:db_rollback' do
    it 'rails db rollback' do
      expect { invoke_all }.to output(output_file('rails_db_rollback')).to_stdout
    end
  end

  describe 'rails:assets_precompile' do
    it 'rails assets precompile' do
      expect { invoke_all }.to output(output_file('rails_assets_precompile')).to_stdout
    end
  end

  # describe 'rollback' do
  #   it 'rollback' do
  #     expect { invoke_all }.to output(output_file('rollback')).to_stdout
  #   end
  # end
end
