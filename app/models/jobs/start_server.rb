# Copyright (c) 2016 Nathan Baum

module Jobs

  class StartServer < Job

    def run
      server.start
    end

  end

end
