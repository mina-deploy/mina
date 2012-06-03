def vh(*args)
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

def stdout
  @out
end

def stderr
  @err
end

def exitstatus
  @result
end
