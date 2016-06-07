require 'spec_helper'

describe Mina::Helpers::Output do
  class DummyOutputHelper
    include Mina::Helpers::Output
  end

  let(:helper) { DummyOutputHelper.new }

  describe '#print_line' do
    it 'prints normally' do
      out, _err = capture_io do
        helper.print_line('ls -al')
      end
      expect(out).to eq("       ls -al\n")
    end

    it 'prints comment' do
      out, _err = capture_io do
        helper.print_line('-> ls -al')
      end
      expect(out).to eq("\e[32m----->\e[0m ls -al\n")
    end

    it 'prints error' do
      out, _err = capture_io do
        helper.print_line('! ls -al')
      end
      expect(out).to eq(" \e[33m!\e[0m     \e[31mls -al\e[0m\n")
    end

    it 'prints command' do
      out, _err = capture_io do
        helper.print_line('$ ls -al')
      end
      expect(out).to eq("       \e[36m$\e[0m \e[36mls -al\e[0m\n")
    end
  end

  describe '#print_stderr' do
    it 'prints stderr' do
      out, _err = capture_io do
        helper.print_stderr('ls -al')
      end
      expect(out).to eq("       \e[31mls -al\e[0m\n")
    end
  end
end
