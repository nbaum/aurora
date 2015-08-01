# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Jobs

  class StopServer < Job

    def run
      server.stop
    end

  end

end
