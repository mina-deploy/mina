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
