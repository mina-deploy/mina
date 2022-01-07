# frozen_string_literal: true

require 'spec_helper'

# IMPORTANT: run only through e2e_run.sh script
describe 'E2E tests', :e2e, type: :rake do
  before do
    load_config 'e2e'
  end

  describe 'deploy without setup' do
    it 'exits with an error message' do
      expect do
        rake.run(['e2e_deploy'])
      end.to raise_error(SystemExit)
         .and output(output_file('e2e_deploy_without_setup')).to_stdout
    end
  end

  describe 'setup' do
    it 'sets up directories' do
      expect do
        rake.run(['setup'])
      end.to output(output_file('e2e_setup')).to_stdout
    end
  end

  describe 'deploy after setup' do
    it 'deploys the app' do
      expect do
        rake.run(['e2e_deploy'])
      end.to output(output_file('e2e_deploy_after_setup')).to_stdout
    end
  end
end
