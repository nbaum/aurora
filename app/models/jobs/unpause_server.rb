module Jobs

  class UnpauseServer < Job

    def run
      server.unpause
    end

  end

end
