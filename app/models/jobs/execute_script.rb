# Copyright (c) 2016 Nathan Baum
module Jobs

  class ExecuteScript < Job

    def run
      state["error"] = nil
      state["result"] = ""
      state_will_change!
      save!
      script = args["script"] ? Script.find(args["script"]) : Script.new(steps: server.script)
      script.execute(server) do |msg|
        self.state["result"] << "\n" << msg
        state_will_change!
        save!
      end
    end

  end

end
