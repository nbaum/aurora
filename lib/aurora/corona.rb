module Aurora
  
  class Corona < BasicObject
    
    def initialize (url, args = {})
      @url = url
      @http = ::Faraday.new(url: url)
      @args = args
    end
    
    def curry (args)
      Corona.new(@url, @args.merge(args))
    end
    
    def method_missing (name, args = {})
      res = @http.post(name.to_s, @args.merge(args).to_yaml)
      if res.status == 200
        ::YAML.load(res.body)
      elsif res.status == 500
        ::Kernel.raise ::Exception, *::YAML.load(res.body)
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
