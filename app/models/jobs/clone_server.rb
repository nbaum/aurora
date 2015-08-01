# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd
module Jobs

  class CloneServer < Job

    def run
      ns = server.clone
      ns.save!
      state["new_server_id"] = ns.id
    end

  end

end
