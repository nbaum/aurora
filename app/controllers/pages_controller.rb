class PagesController < ApplicationController

  def boom
    raise "!"
  end

  def error
    @error = env["action_dispatch.exception"]
    case params["status"]
    when "404"
      render "not_found", layout: false
    else
      render "server_error", layout: false
    end
  end

end
