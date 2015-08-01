# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

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
