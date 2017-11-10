class Corte < ApplicationRecord
  VENTAS_LIMITE = 1000
  GASTOS_LIMITE = 100

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

    Comanda.del_dia(dia).update_all(closed_at: Time.now)
    Corte.create(dia: dia + 1.day, inicial: siguiente_dia)
  end

  def set_subtotals
    self.ventas = Comanda.del_dia(dia).sum(:total)
    self.gastos = Gasto.del_dia(dia).sum(:monto)
    self.total = inicial + ventas - gastos
    self.pagos_con_tarjeta = Comanda.del_dia(dia).where(pago_con_tarjeta: true).sum(:total)
    self.pagos_con_efectivo = self.total - self.pagos_con_tarjeta
    self.sobre = pagos_con_efectivo - siguiente_dia
  end

  def self.actual
    Corte.find_by(dia: Time.now.to_date)
  end

  def self.seed
    dias = Comanda.pluck(:created_at).map(&:to_date).uniq

    dias.each do |dia|
      ventas = Comanda.del_dia(dia).sum(:venta)
      gastos = 0
      total = ventas-gastos
      Corte.create(dia: dia, inicial: 100, ventas: ventas, gastos: 0, total: total, sobre: total-100, siguiente_dia: 100 )
    end
  end

  def self.de_la_semana(inicio, campo)
    semana = [
      inicio.beginning_of_week.to_s,
      (inicio.beginning_of_week + 1.day).to_s,
      (inicio.beginning_of_week + 2.day).to_s,
      (inicio.beginning_of_week + 3.day).to_s,
      (inicio.beginning_of_week + 4.day).to_s,
      (inicio.beginning_of_week + 5.day).to_s,
      (inicio.beginning_of_week + 6.day).to_s
    ]

    Corte.where(dia: semana).pluck(:dia, campo).map do |corte|
      dia = I18n.localize(corte[0], format: "%a")

      {dia => corte[1].to_f}
    end.reduce({}, :merge)
  end
end
