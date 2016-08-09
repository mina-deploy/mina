require 'spec_helper'

RSpec.describe 'init', type: :rake do
  it 'creates new deploy rb' do
    allow(File).to receive(:exist?).and_return(true)
    expect(FileUtils).to receive(:mkdir_p)
    expect(FileUtils).to receive(:cp)

    expect { subject.invoke }.to output("-----> Created ./config/deploy.rb\nEdit this file, then run `mina setup` after.\n").to_stdout
  end

  it 'doesnt create deploy rb if already exists' do
    allow(File).to receive(:exist?).and_return(false)
    expect { subject.invoke }.to raise_error(SystemExit)
  end
end
