json.array!(@storage_pools) do |storage_pool|
  json.extract! storage_pool, :id, :name, :size, :account_id, :host_id
  json.url storage_pool_url(storage_pool, format: :json)
end
