# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Jobs

  class SuspendServer < Job

    def run
      server.suspend
    end

  end

end
