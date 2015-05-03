json.array!(@subnets) do |subnet|
  json.extract! subnet, :id, :kind, :gateway, :prefix, :first, :last, :network_id
  json.url subnet_url(subnet, format: :json)
end
