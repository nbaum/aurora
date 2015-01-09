json.array!(@tariffs) do |tariff|
  json.extract! tariff, :id, :default, :name, :core, :memory, :storage, :address
  json.url tariff_url(tariff, format: :json)
end
