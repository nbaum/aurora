# Copyright (c) 2016 Nathan Baum

module Jobs

  class MigrateServer < Job

    def message
      if status == "running" && server.host
        s = server.migrate_status
        if r = s["ram"]
          "#{r['remaining'] / 1024 / 1024} MB left, #{r['mbps'].to_i} MB/s, #{r['transferred'] / 1024 / 1024} MB transferred"
        else
          "Setting up the migration"
        end
      else
        super
      end
    end

    def cancel
      server.migrate_cancel
    end

    def resume
      run
    end

    def run
      if args["host_id"]
        host = Host.find(args["host_id"])
        server.migrate(host)
      else
        server.evict
      end
    end

  end

end
