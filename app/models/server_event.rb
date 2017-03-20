class ServerEvent < ActiveRecord::Base
  belongs_to :server

  def process_shutdown!
    server.update state: "stopped"
  end

  def process!
    send("process_#{name.downcase}!")
  rescue => e
    p e
  end

end
