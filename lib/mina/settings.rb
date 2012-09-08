# # Settings
# Here are some of the common settings. All settings are optional unless
# otherwise noted.
#
# ### deploy_to
# (Required) Path to deploy to.
#
# ### domain
# (Required) Host name to deploy to.
#
# ### port
# SSH port number.
#
# ### forward_agent
# If set to `true`, enables SSH agent forwarding.
#
# ### identity_file
# The local path to the SSH private key file.

module Mina
  class Settings < Hash
    def method_missing(meth, *args, &blk)
      name = meth.to_s

      return evaluate(self[meth])  if name.size == 1

      # Ruby 1.8.7 doesn't let you do string[-1]
      key, suffix = name[0..-2].to_sym, name[-1..-1]

      case suffix
      when '='
        self[key] = args.first
      when '?'
        include? key
      when '!'
        raise Error, "Setting :#{key} is not set" unless include?(key)
        evaluate self[key]
      else
        evaluate self[meth]
      end
    end

    def evaluate(value)
      if value.is_a?(Proc)
        value.call
      else
        value
      end
    end
  end
end
