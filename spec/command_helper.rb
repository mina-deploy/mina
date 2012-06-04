# Invokes the main 'vh' command.
def run_command(*args)
  require 'open3'

  out = ''
  err = ''
  status = nil

  Open3.popen3(root('bin/vh'), *args) do |i, o, e, t|
    out = o.read
    err = e.read
    status = t.value.exitstatus
  end

  @out = out
  @err = err
  @result = status

  status
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
