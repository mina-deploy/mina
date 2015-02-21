require 'spec_helper'

describe 'Exec Helpers' do
  before :each do
    @exec = Object.new
    @exec.send :extend, Mina::ExecHelpers

    allow(@exec).to receive(:print_char)
  end

  it 'pretty_system' do
    @exec.pretty_system "echo 'Hello there'"

    expect(@exec).to have_received(:print_char).
      with("e").with("r").with("e").with("h").with("t").
      with(" ").
      with("o").with("l").with("l").with("e").with("H")
  end
end
