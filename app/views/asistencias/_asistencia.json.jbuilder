json.extract! asistencia, :id, :mesero_id, :corte_id, :horas, :horas_extra, :retardo, :falta, :created_at, :updated_at
json.url asistencia_url(asistencia, format: :json)
