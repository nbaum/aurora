json.array!(@addresses_networks) do |addresses_network|
  json.extract! addresses_network, :id, :attachment, :server_id, :network_id
  json.url addresses_network_url(addresses_network, format: :json)
end
