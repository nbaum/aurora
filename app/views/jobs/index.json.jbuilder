json.array!(@jobs) do |job|
  json.extract! job, :id, :type, :pending, :data, :state, :owner_id, :server_id
  json.url job_url(job, format: :json)
end
