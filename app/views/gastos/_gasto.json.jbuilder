json.extract! gasto, :id, :monto, :descripcion, :created_at, :updated_at
json.url gasto_url(gasto, format: :json)
