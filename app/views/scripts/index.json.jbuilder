json.array!(@scripts) do |script|
  json.extract! script, :id, :name, :category, :script
  json.url script_url(script, format: :json)
end
