# Copyright (c) 2016 Nathan Baum

module Jobs

  class StopServer < Job

    def run
      server.stop
    end

  end

end
