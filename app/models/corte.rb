# == Schema Information
#
# Table name: cortes
#
#  id                 :uuid             not null, primary key
#  dia                :date
#  inicial            :decimal(, )      default(0.0)
#  ventas             :decimal(, )      default(0.0)
#  sum_gastos         :decimal(, )      default(0.0)
#  total              :decimal(, )      default(0.0)
#  siguiente_dia      :decimal(, )      default(0.0)
#  sobre              :decimal(, )      default(0.0)
#  closed_at          :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  pagos_con_tarjeta  :decimal(, )      default(0.0)
#  pagos_con_efectivo :decimal(, )      default(0.0)
#  deleted_at         :datetime
#  propinas           :decimal(, )
#

class Corte < ApplicationRecord
  include Discard::Model

  belongs_to :sucursal

  has_many :conteos
  has_many :comandas
  has_many :comandas_abiertas, -> { abiertas }, class_name: 'Comanda'
  has_many :gastos
  has_many :ordenes, through: :comandas
  has_many :asistencias

  has_many :meseros, through: :asistencias do
    def activos
      where('asistencias.horas IS NULL').where('asistencias.falta = ?', false)
    end
  end

  validates :dia, uniqueness: { scope: :sucursal_id }
  validates :siguiente_dia, numericality: { greater_than_or_equal_to: 0 }, on: :update
  validates :sobre, numericality: { greater_than_or_equal_to: 0 }, on: :update

  default_scope { order(dia: :desc) }
  scope :de_la_sucursal, ->(sucursal) { where(sucursal: sucursal) if sucursal }

  self.discard_column = :deleted_at

  attr_accessor :caja, :subtotal, :propinas_con_efectivo, :propinas_con_tarjeta, :sobre_sin_propinas

  VENTAS_LIMITE = 2000
  GASTOS_LIMITE = 100

  def propinas_con_efectivo
    comandas.kept.sum(:propina_con_efectivo)
  end

  def propinas_con_tarjeta
    comandas.kept.sum(:propina_con_tarjeta)
  end

  def to_s
    "#{sucursal} - #{dia}"
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

    return false unless save

    reload

    close_asistencias
    finalize_comandas
    #registros_contables!

    true
  end

  def close_asistencias
    current_time = Time.current
    corte_time = dia.to_time

    asistencias.each do |asistencia|
      asistencia.hora_salida = if current_time > corte_time.end_of_day
        corte_time + 23.hours
      else
        current_time
      end

      asistencia.save
    end
  end

  def finalize_comandas
    comandas.update_all(closed_at: Time.now)
  end

  def registros_contables!
    debits = []
    credits = []

    # Los gastos de operacion salen de la caja chica
    debits << {
      account_name: 'Caja Chica',
      amount: pagos_con_efectivo - sum_gastos
    }
    credits << {
      account_name: 'Ventas',
      amount: ventas
    }

    if pagos_con_tarjeta.positive?
      debits << {
        account_name: 'Banco',
        amount: pagos_con_tarjeta
      }
    end
    if sum_gastos.positive?
      debits << {
        account_name: 'Gastos de Operación',
        amount: sum_gastos
      }
    end

    entry = Plutus::Entry.new(
      description: "Corte del día #{dia}",
      date: dia,
      debits: debits,
      credits: credits,
      commercial_document: self
    )

    raise "Registro contable erróneo: #{dia}" unless entry.save

    credits = []
    debits = []

    credits << {
      account_name: 'Caja Chica', amount: sobre
    }
    debits << {
      account_name: 'Caja Fuerte', amount: sobre
    }

    entry = Plutus::Entry.new(
      description: "Retiro del día #{dia}",
      date: dia,
      debits: debits,
      credits: credits,
      commercial_document: self
    )

    raise "Registro contable erróneo: #{dia}" unless entry.save
  end

  def set_subtotals
    self.inicial ||= 0

    comandas_del_dia = comandas.kept

    self.ventas = calculate_ventas
    self.pagos_con_tarjeta = comandas_del_dia.sum(:pago_con_tarjeta)
    self.pagos_con_efectivo = comandas_del_dia.sum(:pago_con_efectivo)

    self.subtotal = inicial + pagos_con_efectivo

    self.sum_gastos = gastos.kept.sum(:monto)
    self.total = inicial + pagos_con_efectivo - sum_gastos
    self.sobre = total - siguiente_dia

    self.propinas = propinas_con_efectivo + propinas_con_tarjeta

    self.caja = total + propinas_con_efectivo
    self.sobre_sin_propinas = sobre - propinas_con_tarjeta
  end

  def calculate_ventas
    comandas.kept.sum(:total)
  end

  def producto_mas_vendido
    count_products.max{ |a,b| a.cantidad <=> b.cantidad }
  end

  def count_products
    ordenes.select('articulo_id, sum("cantidad") as cantidad').group('articulo_id')
  end

  def self.actual(sucursal)
    Corte.find_by(dia: Time.current.to_date, sucursal: sucursal)
  end

  def self.de_la_semana(inicio, campo=:ventas)
    fecha_inicio = inicio.beginning_of_week

    semana = []
    (0..6).each do |numero_dias|
      semana << (fecha_inicio + numero_dias.day).to_s
    end

    Corte.where(dia: semana).pluck(:dia, campo).map do |corte|
      {I18n.localize(corte[0], format: "%a") => corte[1].to_f}
    end.reduce({}, :merge)
  end

  def self.create_next(sucursal)
    Corte.create!(
      dia: Time.now,
      inicial: Corte.de_la_sucursal(sucursal).first&.siguiente_dia,
      sucursal: sucursal
    )
  end
end
