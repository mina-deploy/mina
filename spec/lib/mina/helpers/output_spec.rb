require 'spec_helper'

describe Mina::Helpers::Output do
  class DummyOutputHelper
    include Mina::Helpers::Output
  end

  let(:helper) { DummyOutputHelper.new }

  describe '#print_line' do
    it 'prints normally' do
      expect{ helper.print_line('ls -al') }.to output("       ls -al\n").to_stdout
    end

    it 'prints comment' do
      expect{ helper.print_line('-> ls -al') }.to output("\e[32m----->\e[0m ls -al\n").to_stdout
    end

    it 'prints error' do
      expect{ helper.print_line('! ls -al') }.to output(" \e[33m!\e[0m     \e[31mls -al\e[0m\n").to_stdout
    end

    it 'prints command' do
      expect{ helper.print_line('$ ls -al') }.to output("       \e[36m$\e[0m \e[36mls -al\e[0m\n").to_stdout
    end
  end

  describe '#print_stderr' do
    it 'prints stderr' do
      expect{ helper.print_stderr('ls -al') }.to output("       \e[31mls -al\e[0m\n").to_stdout
    end
  end
end
