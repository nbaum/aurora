# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Jobs

  class ResumeServer < Job

    def run
      server.resume
    end

  end

end
