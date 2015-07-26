module Jobs

  class StartServer < Job

    def run
      server.start
    end

  end

end
