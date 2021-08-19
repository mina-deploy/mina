# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'git', type: :rake do
  before do
    load_default_config
  end

  describe 'git:clone' do
    it 'git clone' do
      expect { invoke_all }.to output(output_file('git_clone')).to_stdout
    end

    it 'git clone with commit' do
      Mina::Configuration.instance.set(:commit, '123456')
      expect { invoke_all }.to output(output_file('git_clone_commit')).to_stdout
      Mina::Configuration.instance.remove(:commit)
    end
  end

  describe 'git:revision' do
    it 'git revision' do
      expect { invoke_all }.to output(output_file('git_revision')).to_stdout
    end
  end

  describe 'git:ensure_pushed' do
    it 'git ensure pushed' do
      expect { invoke_all }.to output(output_file('git_ensure_pushed')).to_stdout
    end
  end
end
