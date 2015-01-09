json.array!(@appliances) do |appliance|
  json.extract! appliance, :id, :name, :internal_class, :template_id
  json.url appliance_url(appliance, format: :json)
end
