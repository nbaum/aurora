json.array!(@servers) do |server|
  json.extract! server, :id, :name, :cores, :memory, :storage, :password, :state, :affinity_group, :appliance_data, :template_id, :host_id, :account_id, :zone_id, :appliance_id, :bundle_id, :published_at, :base_id, :current_id
  json.url server_url(server, format: :json)
end
