json.array!(@addresses) do |address|
  json.extract! address, :id, :ip, :account_id, :server_id, :network_id
  json.url address_url(address, format: :json)
end
