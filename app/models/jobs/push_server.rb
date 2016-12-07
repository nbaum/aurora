# Copyright (c) 2016 Nathan Baum
module Jobs

  class PushServer < Job

    def run
      server.push
    end

  end

end
