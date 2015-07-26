module Jobs

  class ResumeServer < Job

    def run
      server.resume
    end

  end

end
