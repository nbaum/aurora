json.array!(@servers_volumes) do |servers_volume|
  json.extract! servers_volume, :id, :attachment, :server_id, :volume_id
  json.url servers_volume_url(servers_volume, format: :json)
end
