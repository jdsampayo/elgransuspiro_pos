class Corte < ApplicationRecord
  has_many :conteos
  has_many :comandas
  has_many :ordenes, through: :comandas

  acts_as_paranoid

  VENTAS_LIMITE = 1000
  GASTOS_LIMITE = 100

  def propinas
    comandas.sum(:propina)
  end

  def to_s
    dia.to_s
  end

  def cerrado?
    closed_at.present?
  end

  def abierto?
    closed_at.blank?
  end

  def cerrar
    set_subtotals
    self.closed_at = Time.now
    save
    reload
    registro_contable

    Comanda.del_dia(dia).update_all(closed_at: Time.now)
    Corte.create(dia: dia + 1.day, inicial: siguiente_dia)
  end

  def registro_contable
    debits = []
    debits << {account_name: "Caja", amount: pagos_con_efectivo - gastos}
    debits << {account_name: "Banco", amount: pagos_con_tarjeta} if pagos_con_tarjeta > 0
    debits << {account_name: "Gastos de Operación", amount: gastos} if gastos > 0

    entry = Plutus::Entry.new(
      description: "Corte del día #{dia}",
      date: dia,
      debits: debits,
      credits: [{account_name: "Ventas", amount: ventas}]
    )

    unless entry.save
      raise "Registro contable erróneo: #{dia}"
    end
  end

  def set_subtotals
    comandas_del_dia = Comanda.del_dia(dia)

    self.ventas = comandas_del_dia.sum(:total)
    self.pagos_con_tarjeta = comandas_del_dia.con_tarjeta.sum(:total)
    self.pagos_con_efectivo = comandas_del_dia.con_efectivo.sum(:total)

    self.gastos = Gasto.del_dia(dia).sum(:monto)
    self.total = inicial + ventas - gastos
    self.sobre = total - pagos_con_tarjeta - siguiente_dia
  end

  def self.actual
    Corte.find_by(dia: Time.now.to_date)
  end

  def self.de_la_semana(inicio, campo)
    fecha_inicio = inicio.beginning_of_week

    semana = []
    (0..6).each do |numero_dias|
      semana << (fecha_inicio + numero_dias.day).to_s
    end

    Corte.where(dia: semana).pluck(:dia, campo).map do |corte|
      {I18n.localize(corte[0], format: "%a") => corte[1].to_f}
    end.reduce({}, :merge)
  end
end
