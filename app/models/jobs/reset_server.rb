# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Jobs

  class ResetServer < Job

    def run
      server.reset
    end

  end

end
