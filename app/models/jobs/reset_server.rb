# Copyright (c) 2016 Nathan Baum

module Jobs

  class ResetServer < Job

    def run
      server.reset
    end

  end

end
