module Jobs

  class PauseServer < Job

    def run
      server.pause
    end

  end

end
