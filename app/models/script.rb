class Script < ActiveRecord::Base

  class Context < BasicObject

    def initialize (server)
      @server = server
    end

    def server; @server; end

    def reclone ()
      server.stop if server.running?
      if server.template
        log "Re-cloning server from template"
        server.clone_from(server.template)
      else
        fail "No template to clone from"
      end
    end

    def iso_boot (id)
      iso = ::Volume.find(id)
      log "Booting from #{iso.name}"
      server.assign_attributes iso_id: id, boot_order: "d"
      server.changed_attributes.clear
      server.stop rescue nil
      server.start
      server.reload
    end

    def wait (seconds)
      log "Waiting #{seconds} seconds"
      ::Kernel.sleep seconds
    end

    def sendkeys (keys)
      log "Sending key sequence to server console: #{keys.inspect}"
      server.sendkeys(keys)
    end

    def reboot ()
      log "Rebooting server"
      server.stop if server.running?
      server.start
    end

    def stop ()
      log "Stopping script"
      ::Kernel.throw :stop
    end

    def write (path, content)
      log "Writing #{path}"
      server.guest_execute! "set -e; cat > #{path}", content
    end

    def execute (script)
      log "In guest: #{script}"
      server.start rescue nil
      uuid = ::SecureRandom.uuid
      script = "set -e\n" + script.gsub("\r", "")
      path = "/tmp/aurora.script.#{uuid}.sh"
      output = server.guest_execute! "set -e; cat > #{path} && sh #{path} 2>&1; rm #{path}", script
      log "    " + output.strip.split("\n").join("\n    ") if output.strip != ""
    end

    alias sh execute

    def __runcode__ (script, &stater)
      @stater = stater
      instance_eval(script, "(script)", 1)
    end

    private

    def log (message)
      @stater.(message)
    end

  end

  before_save do
    script.gsub!(/\r/, '')
  end

  def execute (server, &stater)
    catch :stop do
      Context.new(server).__runcode__(steps, &stater)
    end
    # YAML.load(steps).each do |step|
    #   send("do_#{step["action"]}", *[server, step["data"]].compact, &stater)
    # end
  end

  # def do_stop (server, &stater)
  # end
  #
  # def do_invoke (server, data, &stater)
  #   stater.("Executing script ##{data}")
  #   Script.find(data).execute(server, &stater)
  # end
  #

  def steps
    super || [{"action" => "shell", "data" => self.script}, {"action" => "stop"}].to_yaml
  end

end
