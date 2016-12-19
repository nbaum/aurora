class Script < ActiveRecord::Base

  before_save do
    script.gsub!(/\r/, '')
  end

  def do_reclone (server, &stater)
    server.stop if server.running?
    if server.template
      stater.("Re-cloning server from template")
      server.clone_from(server.template)
    else
      fail "No template to clone from"
    end
  end

  def do_iso_boot (server, data, &stater)
    iso = Volume.find(data)
    iso_was = server.iso_id
    stater.("Booting from #{iso.name}")
    server.iso_id = iso.id
    server.stop if server.running?
    boot_order_was = server.boot_order
    server.boot_order = "d"
    server.start
    server.boot_order = boot_order_was
    server.boot_order = "cdn"
    server.iso_id = iso_was
    server.save!
  end

  def do_wait (server, data, &stater)
    server.start unless server.running?
    stater.("Waiting #{data} seconds")
    sleep data.to_i
  end

  def do_reboot (server, &stater)
    server.stop if server.running?
    server.start
    stater.("Rebooting server")
  end

  def do_stop (server, &stater)
    # reboot it
  end

  def do_sendkeys (server, data, &stater)
    server.start unless server.running?
    stater.("Sending key sequence to server console: #{data}")
    server.sendkeys(data.gsub("\\n", "\n"))
  end

  def do_invoke (server, data, &stater)
    stater.("Executing script ##{data}")
    Script.find(data).execute(server, &stater)
  end

  def do_shell (server, data, &stater)
    server.start unless server.running?
    stater.("Running a shell script...")
    uuid = SecureRandom.uuid
    data = "set -e\n" + data.gsub("\r", "")
    path = "/tmp/aurora.script.#{uuid}.sh"
    output = server.guest_execute! "set -e; cat > #{path} && sh #{path} 2>&1; rm #{path}", data
    stater.(output)
  end

  def execute (server, &stater)
    YAML.load(steps).each do |step|
      send("do_#{step["action"]}", *[server, step["data"]].compact, &stater)
    end
  end

  def steps
    super || [{"action" => "shell", "data" => self.script}, {"action" => "stop"}].to_yaml
  end

end
