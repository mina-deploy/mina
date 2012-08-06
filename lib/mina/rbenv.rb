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
        # Places the commands required to load rbenv at the start of the deploy queue
        #
        # There is no need to use this function anywhere in your code, 
        # it is already in place in Mina::Helpers#ssh which is the only place
        # it needs to be.
        def load_rbenv(cmd)
            [ "echo \"-----> Loading rbenv\"",
                echo_cmd("source #{bash_profile}"),
                cmd].join("\n")
        end
    end
end
