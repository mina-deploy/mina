module RakeExampleGroup
  extend RSpec::Matchers::DSL

  def self.included(klass)
    klass.instance_eval do
      let(:rake)         { Rake.application }
      let(:task_name)    { self.class.description }
      let(:run_commands) { rake['run_commands']}
      let(:reset!)       { rake['reset!'] }
      subject            { rake[task_name] }

      after do
        subject.reenable
        run_commands.reenable
        reset!.invoke
        reset!.reenable
      end
    end
  end

  def invoke_all(args = nil)
    subject.invoke(args)
    run_commands.invoke
  end

  def output_file(filename)
    content = File.read("./spec/support/outputs/#{filename}.txt")
    Regexp.new(content)
  end
end
