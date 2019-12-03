# == Schema Information
#
# Table name: comandas
#
#  id                      :uuid             not null, primary key
#  venta                   :decimal(, )      default(0.0)
#  descuento               :decimal(, )      default(0.0)
#  total                   :decimal(, )      default(0.0)
#  mesero_id               :uuid
#  deleted_at              :datetime
#  closed_at               :datetime
#  comensales              :bigint(8)        default(1)
#  mesa                    :text             default("PARA LLEVAR")
#  created_at              :datetime
#  updated_at              :datetime
#  pago_con_tarjeta        :boolean          default(FALSE)
#  corte_id                :uuid
#  propina                 :decimal(, )      default(0.0)
#  porcentaje_de_descuento :bigint(8)        default(0)
#

class Comanda < ApplicationRecord
  belongs_to :corte
  belongs_to :mesero
  has_many :ordenes, inverse_of: :comanda
  has_many :articulos, through: :ordenes

  validates :mesa, :mesero, presence: true

  validates :descuento, :total, :venta, numericality: {
    greater_than_or_equal_to: 0
  }
  validates :comensales, numericality: {
    greater_than: 0
  }
  validates :porcentaje_de_descuento, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100,
    message: 'Debe estar entre 0 y 100'
  }

  accepts_nested_attributes_for :ordenes, reject_if: :all_blank, allow_destroy: true

  acts_as_paranoid

  scope :del_dia, ->(dia) {
    where(created_at: dia.beginning_of_day..dia.end_of_day) if dia
  }
  scope :con_tarjeta, -> {
    where(pago_con_tarjeta: true)
  }
  scope :con_efectivo, -> {
    where(pago_con_tarjeta: false)
  }
  scope :cerradas, -> {
    where.not(closed_at: nil)
  }
  scope :abiertas, -> {
    where(closed_at: nil)
  }

  MESAS = [
    'Para Llevar',
    'Entrada 10',
    'Entrada 20',
    'Entrada 30',
    'Entrada 40',
    'Entrada 50',
    'Entrada 60',
    'Sala 10',
    'Sala 20',
    'Sala 30',
    'Sala 40',
    'Sala 50',
    'Sala 60'
  ]

  def actualizar_conteos
    ordenes.each do |orden|
      conteo = Conteo.where(
        articulo_id: orden.articulo.id,
        corte_id: corte.id
      ).first_or_initialize
      conteo.total += orden.cantidad
      conteo.save

      orden.descontar_desechables
    end
  end

  def set_totales
    ordenes.map(&:guardar_precios_historicos)

    self.venta = ordenes.map(&:precio).sum
    self.descuento = self.venta * self.porcentaje_de_descuento / 100
    self.total = venta - descuento
  end

  def to_s
    id
  end

  def tiempo
    closed_at ? closed_at - created_at : Time.current - created_at
  end

  def abierta?
    closed_at.blank?
  end

  def folio
    id.first(8)
  end

  def to_text
    texto = []

    texto << "   #{I18n.l created_at, format: :short}"
    texto << "".ljust(32, '-')

    texto << "Ticket: #{folio.to_s.ljust(9, ' ')} Comensales: #{comensales.to_s.rjust(2, ' ')}"
    texto << "Mesa: #{mesa.ljust(11, ' ')} Mesero: #{mesero.to_s[0,5].rjust(6, ' ')}"

    texto << "".ljust(32, '-')

    texto << " # Nombre            P/U  Precio"
    ordenes.each do |orden|
      texto << orden.to_text
      texto << "Extras: #{orden.extra_ordenes.join(', ')}" if orden.extra_ordenes.present?
    end

    texto << ""

    texto << "Subtotal:                  #{venta.to_s.rjust(5, ' ')}"
    texto << "Descuento (#{porcentaje_de_descuento.to_s.rjust(3, ' ')}%):          #{descuento.to_s.rjust(5, ' ')}"

    texto << "Total:                     #{total.to_s.rjust(5, ' ')}"

    texto << ""
    texto << ""
    texto << ""

    I18n.transliterate(
      texto.map{ |renglon| renglon.ljust(32, ' ' ) }.join("\r\n")
     )
  end

  def print_ticket
    File.open('/dev/usb/lp0', 'w:ascii-8bit') { |f| f.write to_text }
  end

  def switch_payment_method!
    update_attribute(:pago_con_tarjeta, !pago_con_tarjeta)
  end

  def to_sync_json
    to_json( include: { ordenes: { include: :extra_ordenes } } )
  end
end
