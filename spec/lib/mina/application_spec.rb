# frozen_string_literal: true

require 'spec_helper'

describe Mina::Application do
  subject(:application) { described_class.new }

  describe '#top_level_tasks' do
    let(:default_tasks) { ['debug_configuration_variables', 'run_commands'] }

    context 'when `init` task is added' do
      it 'removes default tasks' do
        expect do
          application.collect_command_line_tasks(['init'])
        end.to change(application, :top_level_tasks).from(default_tasks).to(['init'])
      end
    end

    context "when `init` task isn't added" do
      it 'keeps default tasks' do
        expect do
          application.collect_command_line_tasks(['a_task'])
        end.to change(application, :top_level_tasks).from(default_tasks).to(['a_task', *default_tasks])
      end
    end
  end

  describe 'command-line options' do
    ['--version', '-V'].each do |option|
      describe option do
        it 'prints Mina version and exits' do
          expect do
            application.handle_options([option])
          end.to raise_error(SystemExit)
             .and output("Mina, version v#{Mina::VERSION}\n").to_stdout
        end
      end
    end

    ['--verbose', '-v'].each do |option|
      describe option do
        it 'sets verbose flag to true' do
          expect do
            application.handle_options([option])
          end.to change { application.fetch(:verbose) }.from(nil).to(true)
        end
      end
    end

    ['--simulate', '-s'].each do |option|
      describe option do
        it 'sets simulate flag to true' do
          expect do
            application.handle_options([option])
          end.to change { application.fetch(:simulate) }.from(nil).to(true)
        end
      end
    end

    ['--debug-configuration-variables', '-d'].each do |option|
      describe option do
        it 'sets debug_configuration_variables flag to true' do
          expect do
            application.handle_options([option])
          end.to change { application.fetch(:debug_configuration_variables) }.from(nil).to(true)
        end
      end
    end

    describe '--no-report-time' do
      it 'sets skip_report_time flag to true' do
        expect do
          application.handle_options(['--no-report-time'])
        end.to change { application.fetch(:skip_report_time) }.from(nil).to(true)
      end
    end
  end

  describe 'Rake options' do
    let(:options) { application.standard_rake_options }

    it 'shows --verbose' do
      expect(options.any? { |(switch, *)| switch == '--verbose' }).to eq(true)
    end

    it "doesn't show --dry-run" do
      expect(options.any? { |(switch, *)| switch == '--dry-run' }).to eq(false)
    end

    it "doesn't show --quiet" do
      expect(options.any? { |(switch, *)| switch == '--quiet' }).to eq(false)
    end

    it "doesn't show --silent" do
      expect(options.any? { |(switch, *)| switch == '--silent' }).to eq(false)
    end
  end
end
