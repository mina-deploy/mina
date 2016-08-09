require 'spec_helper'

RSpec.describe 'deploy', type: :rake do
  describe 'deploy:force_unlock' do
    it 'deploy force_unlock' do
      expect { invoke_all }.to output(output_file('deploy_force_unlock')).to_stdout
    end
  end

  describe 'deploy:link_shared_paths' do
    it 'deploy link_shared_paths' do
      expect { invoke_all }.to output(output_file('deploy_link_shared_paths')).to_stdout
    end
  end

  describe 'deploy:cleanup' do
    it 'deploy cleanup' do
      expect { invoke_all }.to output(output_file('deploy_cleanup')).to_stdout
    end
  end

  describe 'rollback' do
    it 'rollback' do
      expect { invoke_all }.to output(output_file('rollback')).to_stdout
    end
  end

  describe 'setup' do
    it 'setup' do
      expect { invoke_all }.to output(output_file('setup')).to_stdout
    end
  end
end
