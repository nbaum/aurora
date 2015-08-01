# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Jobs

  class StartServer < Job

    def run
      server.start
    end

  end

end
