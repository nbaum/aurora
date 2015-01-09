json.array!(@networks) do |network|
  json.extract! network, :id, :name, :bridge, :gateway, :prefix, :first, :last, :account_id, :bundle_id, :zone_id
  json.url network_url(network, format: :json)
end
