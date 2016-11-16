require 'spec_helper'

describe Mina::Commands do
  let(:commands) { Mina::Commands.new(:default) }

  describe '#command' do
    it 'adds a command to the queue' do
      commands.command('ls -al')

      expect(commands.queue[:default]).to include('ls -al')
    end

    it 'indents a command' do
      commands.command('ls -al', indent: 4)

      expect(commands.queue[:default]).to include('    ls -al')
    end

    context 'when verbose' do
      before { Mina::Configuration.instance.set(:verbose, true) }
      after { Mina::Configuration.instance.remove(:verbose) }

      it 'adds a echo command to the queue' do
        commands.command('ls -al')

        expect(commands.queue[:default]).to include("echo \\$\\ ls\\ -al &&\nls -al")
      end

      it 'adds a silent command to the queue' do
        commands.command('ls -al', quiet: true)

        expect(commands.queue[:default]).to include('ls -al')
      end
    end
  end

  describe '#comment' do
    it 'adds a comment to the queue' do
      commands.comment('ls -al')

      expect(commands.queue[:default]).to include('echo "-----> ls -al"')
    end

    it 'indents a comment' do
      commands.comment('ls -al', indent: 4)

      expect(commands.queue[:default]).to include('    echo "-----> ls -al"')
    end
  end

  describe '#delete' do
    it 'returns a stage and deletes it from commands' do
      commands.command('ls -al')

      expect(commands.delete(:default)).to include('ls -al')
      expect(commands.queue[:default]).to be_empty
    end
  end

  describe '#process' do
    before do
      commands.command('ls -al')
      commands.command('pwd')
    end

    it 'joins all the commands' do
      expect(commands.process).to eq("ls -al\npwd")
    end

    it 'joins all the commands within a path' do
      expect(commands.process('some/path')).to eq('(cd some/path && ls -al && pwd && cd -)')
    end

    context 'when verbose' do
      before { Mina::Configuration.instance.set(:verbose, true) }
      after { Mina::Configuration.instance.remove(:verbose) }

      it 'joins all the commands within a path and echoes it' do
        expect(commands.process('some/path')).to eq("(cd some/path && echo \"$ cd some/path\" && ls -al && pwd && cd -)")
      end
    end
  end

  describe '#run' do
    it 'calls run on a backend' do
      commands.command('ls -al')
      runner = double(:runner)
      allow(Mina::Runner).to receive(:new).and_return(runner)
      expect(runner).to receive(:run).and_return(true)
      commands.run(:local)
    end
  end
end
