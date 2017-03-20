json.extract! server_event, :id, :server_id, :name, :data, :created_at, :updated_at
json.url server_event_url(server_event, format: :json)