module VanHelsing
  class Settings < Hash
    def method_missing(meth, *args, &blk)
      if meth =~ /^(.*)=$/
        self[$1.to_sym] = args.first
      elsif meth =~ /^(.*)\?$/
        !! self[$1.to_sym]
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
