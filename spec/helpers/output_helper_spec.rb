require 'spec_helper'

describe 'Output Helpers' do
  before :each do
    @out = Object.new
    @out.send :extend, Mina::OutputHelpers

    allow(@out).to receive(:print_stdout)
    allow(@out).to receive(:print_status)
    allow(@out).to receive(:print_error)
    allow(@out).to receive(:print_command)
    allow(@out).to receive(:print_clear)
  end

  it 'print_str to stdout' do
    @out.print_str "Hello there\n"

    expect(@out).to have_received(:print_stdout).with("Hello there\n")
  end

  it 'print_str to status' do
    @out.print_str "-----> Getting password"

    expect(@out).to have_received(:print_status).with("Getting password")
  end

  it 'print_str to status (2)' do
    @out.print_str "-> Getting password"

    expect(@out).to have_received(:print_status).with("Getting password")
  end

  it 'print_str to error' do
    @out.print_str "! Something went wrong"

    expect(@out).to have_received(:print_error).with("Something went wrong")
  end
end
