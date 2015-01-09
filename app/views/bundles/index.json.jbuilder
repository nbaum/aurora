json.array!(@bundles) do |bundle|
  json.extract! bundle, :id, :name, :published_at, :account_id
  json.url bundle_url(bundle, format: :json)
end
