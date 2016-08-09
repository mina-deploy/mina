require 'spec_helper'

describe Mina::Application do
  # let(:app) { Rake.application }
  #
  # %w(quiet silent dry-run).each do |switch|
  #   it "doesn't include --#{switch} in help" do
  #     binding.pry
  #     expect(out).not_to match(/--#{switch}/)
  #   end
  # end
  #
  # it 'runs adds two default tasks to the task list' do
  #   expect(subject.top_level_tasks).to include(:debug_configuration_variables)
  #   expect(subject.top_level_tasks).to include(:run_commands)
  # end
  #
  # it 'overrides the rake method, but still prints the rake version' do
  #   out = capture_io do
  #     flags '--version', '-V'
  #   end
  #   expect(out).to match(/\bMina, version\b/)
  #   expect(out).to match(/\bv#{Mina::VERSION}\b/)
  # end
  #
  # it 'enables simulation mode, and sets the backend Mina::Runner::Printer' do
  #   capture_io do
  #     flags '--simulate', '-s'
  #   end
  #   expect(Mina::Configuration.instance.fetch(:simulate)).to be true
  # end
  #
  # it 'enables printing all config variables on command line parameter' do
  #   capture_io do
  #     flags '--debug-configuration-variables', '-d'
  #   end
  #   expect(Mina::Configuration.instance.fetch(:debug_configuration_variables)).to be true
  # end
end
