# Makes mina work alot better with rbenv
settings.bash_profile ||= '~/.bash_profile'

namespace :rbenv do  
    desc "Returns the current ruby version"
    task :ruby_version do
        queue %[echo "-----> Checking Ruby version"
        #{echo_cmd "ruby -v"}]
    end
end

module Mina
    module Helpers
        def rbenv_loaded
            true
        end
        
        def load_rbenv(cmd)
            [ "echo \"-----> Loading rbenv\"",
                echo_cmd("source #{bash_profile}"),
                cmd].join("\n")
        end
    end
end
