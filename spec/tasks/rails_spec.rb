require 'spec_helper'

RSpec.describe 'rails', type: :rake do
  describe 'console' do
    it 'starts console' do
      expect { invoke_all }.to output(output_file('rails_console')).to_stdout
    end
  end

  describe 'log' do
    it 'tails log' do
      expect { invoke_all }.to output(output_file('rails_log')).to_stdout
    end
  end

  describe 'rails:db_migrate' do
    subject { rake['rails:db_migrate'] }

    context 'when outside deploy block' do
      around do |example|
        original_flag = Mina::Configuration.instance.remove(:deploy_block)
        example.run
        Mina::Configuration.instance.set(:deploy_block, original_flag)
      end

      it 'exits with an error message' do
        expect do
          invoke_all
        end.to raise_error(SystemExit)
           .and output(output_file('rails_db_migrate_outside_deploy_block')).to_stdout
      end
    end

    context 'with force_migrate flag' do
      before do
        Mina::Configuration.instance.set(:force_migrate, true)
        Mina::Configuration.instance.set(:deploy_block, true)
      end

      after do
        Mina::Configuration.instance.remove(:force_migrate)
        Mina::Configuration.instance.set(:deploy_block, false)
      end

      it 'runs rails db:migrate' do
        expect do
          invoke_all
        end.to output(output_file('rails_db_migrate_force_migrate')).to_stdout
      end
    end

    context 'without force_migrate flag' do
      before do
        Mina::Configuration.instance.set(:deploy_block, true)
      end

      after do
        Mina::Configuration.instance.set(:deploy_block, false)
      end

      it 'runs rails db:migrate but checks for changes first' do
        expect do
          invoke_all
        end.to output(output_file('rails_db_migrate_with_diff')).to_stdout
      end
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
    subject { rake['rails:assets_precompile'] }

    context 'when outside deploy block' do
      around do |example|
        original_flag = Mina::Configuration.instance.remove(:deploy_block)
        example.run
        Mina::Configuration.instance.set(:deploy_block, original_flag)
      end

      it 'exits with an error message' do
        expect do
          invoke_all
        end.to raise_error(SystemExit)
           .and output(output_file('rails_assets_precompile_outside_deploy_block')).to_stdout
      end
    end

    context 'with force_asset_precompile flag' do
      before do
        Mina::Configuration.instance.set(:force_asset_precompile, true)
        Mina::Configuration.instance.set(:deploy_block, true)
      end

      after do
        Mina::Configuration.instance.remove(:force_asset_precompile)
        Mina::Configuration.instance.set(:deploy_block, false)
      end

      it 'runs rails assets:precompile' do
        expect do
          invoke_all
        end.to output(output_file('rails_assets_precompile_force_precompile')).to_stdout
      end
    end

    context 'without force_asset_precompile flag' do
      before do
        Mina::Configuration.instance.set(:deploy_block, true)
      end

      after do
        Mina::Configuration.instance.set(:deploy_block, false)
      end

      it 'runs rails assets:precompile but checks for changes first' do
        expect do
          invoke_all
        end.to output(output_file('rails_assets_precompile_with_diff')).to_stdout
      end
    end
  end

  describe 'rails:assets_clean' do
    it 'rails assets clean' do
      expect { invoke_all }.to output(output_file('rails_assets_clean')).to_stdout
    end
  end

  describe 'rails:db_schema_load' do
    it 'rails db schema load' do
      expect { invoke_all }.to output(output_file('rails_db_schema_load')).to_stdout
    end
  end

  describe 'rails' do
    subject { rake['rails'] }

    context 'without arguments' do
      it 'exits with an error message' do
        expect do
          invoke_all
        end.to raise_error(SystemExit)
           .and output(output_file('rails_without_arguments')).to_stdout
      end
    end

    context 'with arguments' do
      it 'executes the arguments' do
        expect do
          invoke_all('db:rollback STEP=2')
        end.to output(output_file('rails_with_arguments')).to_stdout
      end
    end
  end

  describe 'rake' do
    subject { rake['rake'] }

    context 'without arguments' do
      it 'exits with an error message' do
        expect do
          invoke_all
        end.to raise_error(SystemExit)
           .and output(output_file('rake_without_arguments')).to_stdout
      end
    end

    context 'with arguments' do
      it 'executes the arguments' do
        expect do
          invoke_all('db:primary:migrate')
        end.to output(output_file('rake_with_arguments')).to_stdout
      end
    end
  end
end
