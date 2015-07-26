module Jobs

  class ResetServer < Job

    def run
      server.reset
    end

  end

end
