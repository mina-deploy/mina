module VanHelsing
  class Settings < Hash
    def method_missing(meth, *args, &blk)
      if meth =~ /^(.*)=$/
        self[$1.to_sym] = args.first
      elsif meth =~ /^(.*)\?$/
        include? $1.to_sym
      elsif meth =~ /^(.*)!$/
        raise Error, "Setting :#{$1} is not set" unless include?($1.to_sym)
        evaluate self[meth]
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
