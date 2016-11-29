# Copyright (c) 2016 Nathan Baum

module Jobs

  class UnpauseServer < Job

    def run
      server.unpause
    end

  end

end
