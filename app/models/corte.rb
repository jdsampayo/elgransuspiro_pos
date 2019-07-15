# == Schema Information
#
# Table name: cortes
#
#  id                 :uuid             not null, primary key
#  dia                :date
#  inicial            :decimal(, )      default(0.0)
#  ventas             :decimal(, )      default(0.0)
#  gastos             :decimal(, )      default(0.0)
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
  has_many :conteos
  has_many :comandas
  has_many :ordenes, through: :comandas
  has_many :asistencias

  has_many :meseros, through: :asistencias do
    def activos
      where('asistencias.horas IS NULL').where('asistencias.falta = ?', false)
    end
  end

  validates :dia, uniqueness: true

  acts_as_paranoid

  VENTAS_LIMITE = 2000
  GASTOS_LIMITE = 100

  def calcular_propinas
    comandas.sum(:propina)
  end

  def reparto_de_propinas
    propinas / asistencias.count if propinas.present? && asistencias&.count > 0
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

    finalize_comandas
    registros_contables!

    nuevo_corte = Corte.create(dia: dia + 1.day, inicial: siguiente_dia)
    nuevo_corte.syncronize_create
  end

  def finalize_comandas
    Comanda.del_dia(dia).update_all(closed_at: Time.now)
  end

  def registros_contables!
    debits = []
    credits = []

    # Los gastos de operacion salen de la caja chica
    debits << {
      account_name: 'Caja Chica',
      amount: pagos_con_efectivo - gastos
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
    if gastos.positive?
      debits << {
        account_name: 'Gastos de Operación',
        amount: gastos
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
    comandas_del_dia = comandas

    self.ventas = comandas_del_dia.sum(:total)
    self.pagos_con_tarjeta = comandas_del_dia.con_tarjeta.sum(:total)
    self.pagos_con_efectivo = comandas_del_dia.con_efectivo.sum(:total)

    self.gastos = Gasto.where(corte_id: id).sum(:monto)
    self.total = inicial + ventas - gastos
    self.sobre = caja_chica - siguiente_dia

    self.propinas = calcular_propinas
  end

  def caja_chica
    total - pagos_con_tarjeta
  end

  # Por si se quedan a trabajas despues de las 00:00am
  def self.actual
    Corte.find_by(dia: (Time.current - 3.hours).to_date)
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

end
