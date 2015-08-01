# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Jobs

  class DestroyServer < Job

    def run
      server.destroy
    end

  end

end
