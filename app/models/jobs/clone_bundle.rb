# Copyright (c) 2016 Nathan Baum
module Jobs

  class CloneBundle < Job

    def run
      ns = bundle.clone
      ns.save!
      state["new_server_id"] = ns.id
    end

  end

end
