# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'init', type: :rake do
  before do
    load_default_config
  end

  it 'creates new deploy rb' do
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:exist?).with('./config/deploy.rb').and_return(false)
    allow(FileUtils).to receive(:mkdir_p).and_return(true)
    allow(FileUtils).to receive(:cp).and_return(true)

    expect do
      task.invoke
    end.to output("-----> Created ./config/deploy.rb\nEdit this file, then run `mina setup` after.\n").to_stdout
  end

  it 'doesnt create deploy rb if already exists' do
    allow(File).to receive(:exist?).and_return(false)
    expect { task.invoke }.to raise_error(SystemExit).and output(/You already have/).to_stdout
  end
end
