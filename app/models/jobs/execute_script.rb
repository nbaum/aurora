# Copyright (c) 2016 Nathan Baum
module Jobs

  class ExecuteScript < Job

    def run
      state["result"] = ""
      script = Script.find(args["script"])
      id = script.id
      script.script.split(/^\#\#$/).each.with_index do |part, i|
        part = "set -e\n" + part
        path = "/tmp/aurora.script.#{id}.#{i}.sh"
        output = server.guest_execute! "cat > #{path} && source #{path} 2>&1 && rm #{path}", part
        state["result"] << output
        save!
      end
      state["result"]
    end

  end

end
