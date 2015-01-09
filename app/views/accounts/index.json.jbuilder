json.array!(@accounts) do |account|
  json.extract! account, :id, :name, :balance, :tariff_id, :zone_id
  json.url account_url(account, format: :json)
end
