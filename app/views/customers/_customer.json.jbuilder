json.extract! customer, :id, :name, :deleted, :created_at, :updated_at
json.url customer_url(customer, format: :json)
