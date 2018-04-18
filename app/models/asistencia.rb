class Asistencia < ApplicationRecord
  belongs_to :mesero
  belongs_to :corte

  before_update :calcular_horas

  def calcular_horas
    self.horas = ((updated_at - created_at) / 1.hour).to_i
  end

  def preview_de_salida
    ((Time.current - created_at) / 1.hour).to_i
  end

  def self.meseros_del_dia
    meseros_registrados = Asistencia.where(corte: Corte.actual).pluck(:mesero_id)
    Mesero.where.not(id: meseros_registrados)
  end
end
