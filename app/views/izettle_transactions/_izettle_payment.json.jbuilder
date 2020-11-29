json.extract! izettle_payment, :id, :payed_at, :amount, :type, :transaction_id, :comanda_id, :created_at, :updated_at
json.url izettle_payment_url(izettle_payment, format: :json)
