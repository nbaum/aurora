module Aurora
  
  class Corona < BasicObject
    
    class Error < ::StandardError
      def initialize (message = nil, klass, backtrace)
        super(message)
        @klass, @backtrace = klass, backtrace
      end
      def backtrace
        @backtrace
      end
    end
    
    def initialize (url, args = {})
      @url = url
      @http = ::Faraday.new(url: url)
      @args = args
    end
    
    def curry (args)
      Corona.new(@url, @args.merge(args))
    end
    
    def method_missing (name, args = {})
      ::Kernel.raise ::TypeError, "API arguments aren't a hash: #{args.inspect}" unless ::Hash === args
      res = @http.post(name.to_s, @args.merge(args).to_yaml)
      if res.status == 200
        ::YAML.load(res.body)
      elsif res.status == 500
        klass, message, backtrace = *::YAML.load(res.body)
        ::Kernel.raise Error.new(message, klass, backtrace + ["/dev/null:0:in `API call to #{@url}'"] + ::Kernel.caller)
      else
        ::Kernel.raise "Unexpected Corona status #{res.status}"
      end
    end
    
    def local_variables
      {}
    end
    
    def instance_variables
      {}
    end
    
  end
  
end
