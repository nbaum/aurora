# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Jobs

  class UnpauseServer < Job

    def run
      server.unpause
    end

  end

end
