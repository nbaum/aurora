# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class PagesController < ApplicationController

  def boom
    fail "!"
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
