module Jobs

  class StopServer < Job

    def run
      server.stop
    end

  end

end
