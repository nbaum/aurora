module Jobs

  class DestroyServer < Job

    def run
      server.destroy
    end

  end

end
