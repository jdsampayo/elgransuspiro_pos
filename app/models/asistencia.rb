class Asistencia < ApplicationRecord
  include Syncronize

  belongs_to :mesero
  belongs_to :corte

  before_create :checar_retardo
  before_update :calcular_horas

  scope :activas, -> {
    where(horas: nil).where(falta: false)
  }

  ENTRADA_HORARIOS = {
    matutino: 9,
    vespertino: 15,
    intermedio: 18
  }

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

    self.retardo
  end

  def obtener_entrada_mas_cercana(hora_actual)
    valores_absolutos = ENTRADA_HORARIOS.map do |key, value|
      { key => (value - hora_actual).abs }
    end.reduce(:merge)

    ordenados = Hash[valores_absolutos.sort_by {|k, v| v}]

    ENTRADA_HORARIOS[ordenados.first.first]
  end

  def self.meseros_del_dia
    meseros_registrados = Asistencia.where(corte: Corte.actual).pluck(:mesero_id)
    Mesero.where.not(id: meseros_registrados)
  end
end
