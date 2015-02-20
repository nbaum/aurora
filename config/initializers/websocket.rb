class WebSocket::Handshake::Handler::Server04
  def handshake_keys
    def handshake_keys
      [
        ['Upgrade', 'websocket'],
        ['Connection', 'Upgrade'],
        ['Sec-WebSocket-Accept', signature],
        ['Sec-WebSocket-Protocol', 'base64']
      ]
    end
  end
end

