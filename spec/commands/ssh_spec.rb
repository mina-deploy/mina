require 'spec_helper'
require 'command_helper'

describe "Invoking the 'mina' command in a project" do

  it "should build ssh command even with frozen String as a domain" do
    ENV['simulate'] = 'true'
    rake {
      set :domain, 'localhost'.freeze
      ssh("ls")
    }
  end

end
