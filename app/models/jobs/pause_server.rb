# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Jobs

  class PauseServer < Job

    def run
      server.pause
    end

  end

end
