module Jobs

  class SuspendServer < Job

    def run
      server.suspend
    end

  end

end
