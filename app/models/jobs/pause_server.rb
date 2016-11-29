# Copyright (c) 2016 Nathan Baum

module Jobs

  class PauseServer < Job

    def run
      server.pause
    end

  end

end
