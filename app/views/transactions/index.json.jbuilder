json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :amount, :description, :account_id
  json.url transaction_url(transaction, format: :json)
end
