# frozen_string_literal: true

require 'spec_helper'

describe Mina::DSL, type: :rake do
  before do
    load_default_config
    load_config 'dsl'
  end

  describe '#reset!' do
    let(:task_name) { 'reset_task' }

    it 'clears all commands before it' do
      expect do
        invoke_all
      end.to output(output_file('dsl_reset')).to_stdout
    end
  end

  describe '#run' do
    context 'when one run block is inside another' do
      let(:task_name) { 'one_run_inside_another' }

      it 'exits with an error message' do
        expect do
          invoke_all
        end.to raise_error(SystemExit)
           .and output(/Can't use run block inside another run block./).to_stdout
      end
    end

    context 'when backend is :local' do
      let(:task_name) { 'local_run' }

      it 'executes commands locally' do
        expect do
          invoke_all
        end.to output(output_file('dsl_local_run')).to_stdout
      end
    end

    context 'when backend is :remote' do
      let(:task_name) { 'remote_run' }

      it 'executes commands on the server' do
        expect do
          invoke_all
        end.to output(output_file('dsl_remote_run')).to_stdout
      end
    end

    context "when backend doesn't exist" do
      let(:task_name) { 'nonexistent_run' }

      # TODO: refactor for more user-friendly error handling
      it 'raises a runtime error' do
        expect do
          invoke_all
        end.to raise_error(RuntimeError, /Don't know how to build task 'nonexistent_environment'/)
      end
    end
  end

  describe '#on' do
    let(:task_name) { 'on_stage_task' }

    it 'executes the command in the given stage' do
      expect do
        invoke_all
      end.to output(output_file('dsl_on')).to_stdout
    end
  end

  describe '#in_path' do
    let(:task_name) { 'in_path_task' }

    it 'executes the command in the given path' do
      expect do
        invoke_all
      end.to output(output_file('dsl_in_path')).to_stdout
    end
  end

  describe '#deploy' do
    let(:task_name) { 'deploy_block_task' }

    it 'executes the deploy script and commands on remote' do
      expect do
        invoke_all
      end.to output(output_file('dsl_deploy')).to_stdout
    end
  end
end
