# Copyright (c) 2016 Nathan Baum

class WebSocket::Handshake::Handler::Server04

  def handshake_keys
    [
      %w[Upgrade websocket],
      %w[Connection Upgrade],
      ["Sec-WebSocket-Accept", signature],
      ["Sec-WebSocket-Protocol", "base64"],
    ]
  end

end
