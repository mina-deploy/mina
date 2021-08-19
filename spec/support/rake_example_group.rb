# frozen_string_literal: true

module RakeExampleGroup
  extend RSpec::SharedContext

  subject(:task)     { rake[task_name] }

  let(:rake)         { Rake.application }
  let(:task_name)    { self.class.description }
  let(:run_commands) { rake['run_commands'] }
  let(:reset!)       { rake['reset!'] }

  after do
    reset!.invoke
  end

  def load_default_config
    load_config 'default'
  end

  def load_config(config_name)
    Rake.load_rakefile(Dir.pwd + "/spec/configs/#{config_name}.rb")
  end

  def invoke_all(*args)
    task.invoke(*args)
    run_commands.invoke
  end

  def output_file(filename)
    content = File.read("./spec/support/outputs/#{filename}.txt")
    Regexp.new(content)
  end
end
