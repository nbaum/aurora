json.array!(@volumes) do |volume|
  json.extract! volume, :id, :name, :size, :ephemeral, :optical, :server_id, :base_id, :account_id, :bundle_id, :storage_pool_id, :published_at
  json.url volume_url(volume, format: :json)
end
