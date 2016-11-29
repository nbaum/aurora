# Copyright (c) 2016 Nathan Baum

module Jobs

  class DestroyServer < Job

    def run
      server.destroy
    end

  end

end
