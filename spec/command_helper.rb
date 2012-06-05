# Invokes the main 'vh' command.
def run_command(*args)
  out = ''
  err = ''
  @result = nil

  if ENV['rake']
    rake_version = "~> #{ENV['rake'] || '0.9'}.0"
    script  = %[require 'rubygems' unless Object.const_defined?(:Gem);]
    script += %[gem 'rake', '#{rake_version}';]
    script += %[load '#{root('bin/vh')}']
    cmd = ['ruby', '-e', "#{script}", "--", *args]
  else
    cmd = [root('bin/vh'), *args]
  end

  status =
    VanHelsing::Tools.popen4(*cmd) do |pid, i, o, e|
      out = o.read
      err = e.read
    end

  @result = status.exitstatus

  @out = out
  @err = err

  @result
end

# Invokes the main 'vh' command and ensures the exit status is success.
def vh(*args)
  run_command *args
  if exitstatus != 0 && ENV['verbose']
    puts stdout
    puts stderr
  end

  exitstatus.should == 0
end

def stdout
  @out
end

def stderr
  @err
end

def exitstatus
  @result
end
