json.array!(@zones) do |zone|
  json.extract! zone, :id, :name, :dns1, :dns2
  json.url zone_url(zone, format: :json)
end
