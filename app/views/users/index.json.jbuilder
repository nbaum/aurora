json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :password_digest, :account_id, :administrator, :ssh_keys
  json.url user_url(user, format: :json)
end
