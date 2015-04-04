json.array!(@sessions) do |session|
  json.extract! session, :id, :user
  json.url session_url(session, format: :json)
end
