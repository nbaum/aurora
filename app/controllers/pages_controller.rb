# Copyright (c) 2016 Nathan Baum

class PagesController < ApplicationController

  skip_before_filter :check_authentication, only: [:keys]

  def keys
    render text: User.to_a.map(&:ssh_keys).join("\n"), content_type: "text/plain"
  end

  def boom
    raise "!"
  end

  def error
    @error = env["action_dispatch.exception"]
    case params["status"]
    when "404"
      render "not_found", layout: false, status: params["status"].to_i
    else
      render "server_error", layout: false, status: (params["status"] || "500").to_i
    end
  end

end
