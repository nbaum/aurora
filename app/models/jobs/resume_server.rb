# Copyright (c) 2016 Nathan Baum

module Jobs

  class ResumeServer < Job

    def run
      server.resume
    end

  end

end
