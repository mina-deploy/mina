require 'spec_helper'

RSpec.describe 'git', type: :rake do
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
end
