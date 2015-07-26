module Aurora

  class Corona < BasicObject

    def self.defapi (*names)
      names.each do |name|
        define_method(name) do |args = {}|
          invoke(name, args)
        end
      end
    end

    # Server APIs
    defapi :start, :stop, :pause, :unpause, :suspend, :resume, :reset
    defapi :migrate_to, :migrate_from

    # Volume APIs
    defapi :realize, :delete, :list_volumes

    def initialize (url, args = {})
      @url = url
      @http = ::Faraday.new(url: url, request: { timeout: nil })
      @args = args
    end

    def invoke (name, args)
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
