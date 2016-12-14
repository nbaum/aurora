# Copyright (c) 2016 Nathan Baum
module Jobs

  class ExecuteScript < Job

    def run
      script = Script.find(args["script"])
      path = "/tmp/aurora.script.#{script.id}.sh"
      server.guest_execute! "cat > #{path} && source #{path} 2>&1 && rm #{path}", script.script
    end

  end

end
