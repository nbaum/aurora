json.array!(@hosts) do |host|
  json.extract! host, :id, :name, :cores, :memory, :storage, :url, :address, :compute, :storage, :zone_id
  json.url host_url(host, format: :json)
end
