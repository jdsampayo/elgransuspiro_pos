json.extract! insumo, :id, :nombre, :cantidad_actual, :unidad, :deleted_at, :created_at, :updated_at
json.url insumo_url(insumo, format: :json)
