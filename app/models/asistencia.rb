# == Schema Information
#
# Table name: asistencias
#
#  id           :uuid             not null, primary key
#  mesero_id    :uuid
#  corte_id     :uuid
#  horas        :bigint
#  horas_extra  :bigint
#  retardo      :boolean          default(FALSE), not null
#  falta        :boolean          default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  hora_entrada :datetime
#  hora_salida  :datetime
#

class Asistencia < ApplicationRecord
  belongs_to :mesero
  belongs_to :corte

  before_create :checar_retardo
  before_update :calcular_horas

  scope :activas, lambda {
    where(horas: nil).where(falta: false)
  }

  ENTRADA_HORARIOS = {
    matutino: 7,
    vespertino: 15,
    intermedio: 19
  }.freeze

  def calcular_horas
    self.horas = ((hora_salida - hora_entrada) / 1.hour).to_i if hora_salida
  end

  def preview_de_salida
    ((Time.current - hora_entrada) / 1.hour).to_i
  end

  def checar_retardo(tiempo_actual=Time.current)
    hora_actual = tiempo_actual.hour
    hora_entrada = obtener_entrada_mas_cercana(hora_actual)

    if hora_actual < hora_entrada
      self.retardo = false
    elsif hora_actual == hora_entrada
      self.retardo = true if tiempo_actual.min > 10
    else
      self.retardo = true
    end

    retardo
  end

  def obtener_entrada_mas_cercana(hora_actual)
    valores_absolutos = ENTRADA_HORARIOS.map do |key, value|
      { key => (value - hora_actual).abs }
    end.reduce(:merge)

    ordenados = Hash[valores_absolutos.sort_by { |_, v| v }]

    ENTRADA_HORARIOS[ordenados.first.first]
  end

  def puede_salir?
    horas.blank? && !falta
  end

  def self.meseros_del_dia_por_asistir(current_sucursal)
    registrados = Asistencia.where(corte: Corte.actual(current_sucursal)).pluck(:mesero_id)
    Mesero.kept.where.not(id: registrados)
  end
end
