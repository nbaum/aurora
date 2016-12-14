# Copyright (c) 2016 Nathan Baum
module Jobs

  class GuestExecute < Job

    def run
      server.guest_execute! args["command"]
    end

  end

end
