json.data do
  json.array! @servers do |server|
    json.type "server"
    json.id server.id
    json.attributes do
      json.(server, :name, :tags, :state)
      json.address server.addresses.first&.ip&.to_s
    end
    json.links do
      json.self server_url(server)
      json.start start_server_url(server)
      json.stop stop_server_url(server)
      json.pause pause_server_url(server)
      json.clone clone_server_url(server)
    end
  end
end
