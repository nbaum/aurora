# Copyright (c) 2016 Nathan Baum
module Jobs

  class ExecuteScript < Job

    def run
      state["result"] = ""
      script = Script.find(args["script"])
      script.split(/^##$/).each do |part|
        part = "set -e\n" + part
        path = "/tmp/aurora.script.#{script.id}.sh"
        output = server.guest_execute! "cat > #{path} && source #{path} 2>&1 && rm #{path}", script.script
        state["result"] << output
      end
      state["result"]
    end

  end

end
