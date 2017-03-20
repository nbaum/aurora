# Copyright (c) 2016 Nathan Baum

class CallbackController < ApplicationController
  skip_before_action :check_authentication
  skip_before_action :verify_authenticity_token

  def server_event
    s = Server.find(params["id"])
    e = s.events.create! name: params["event"], data: params["data"], created_at: Time.at(params["time"].to_f)
    e.process!
  rescue => e
    p e
  end

end
