# Copyright (c) 2016 Nathan Baum

module Jobs

  class SuspendServer < Job

    def run
      server.suspend
    end

  end

end
