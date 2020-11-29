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
#  comensales              :bigint           default(1)
#  mesa                    :text             default("PARA LLEVAR")
#  created_at              :datetime
#  updated_at              :datetime
#  es_pago_con_tarjeta     :boolean          default(FALSE)
#  corte_id                :uuid
#  propina_con_efectivo    :decimal(, )      default(0.0)
#  porcentaje_de_descuento :bigint           default(0)
#  propina_con_tarjeta     :decimal(, )      default(0.0)
#  pago_con_efectivo       :decimal(, )      default(0.0)
#  pago_con_tarjeta        :decimal(, )      default(0.0)
#

class Comanda < ApplicationRecord
  include Discard::Model

  before_create :set_folio

  belongs_to :corte
  belongs_to :mesero

  has_one :izettle_purchase
  has_one :sucursal, through: :corte
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
  validate :monto_pagado, if: :closing

  accepts_nested_attributes_for :ordenes, reject_if: :all_blank, allow_destroy: true

  self.discard_column = :deleted_at

  attr_accessor :closing

  scope :del_dia, ->(dia) {
    joins(:corte).where('cortes.dia' => dia) if dia
  }
  scope :cerradas, -> {
    where.not(closed_at: nil)
  }
  scope :abiertas, -> {
    where(closed_at: nil)
  }
  scope :con_monto_total_tarjeta, ->(monto) {
    where('pago_con_tarjeta + propina_con_tarjeta = ?', monto) if monto
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
    ordenes.reject { |orden| orden.articulo.nil? }.map(&:set_precios_historicos)

    self.venta = ordenes.map(&:precio).sum
    self.descuento = self.venta * self.porcentaje_de_descuento / 100
    self.total = venta - descuento
  end

  def to_s
    folio
  end

  def tiempo
    closed_at ? closed_at - created_at : Time.current - created_at
  end

  def pago
    pago_con_tarjeta + pago_con_efectivo
  end

  def propina
    propina_con_tarjeta + propina_con_efectivo
  end

  def abierta?
    closed_at.blank?
  end

  def to_text
    texto = []

    texto << ""

    texto << "   #{I18n.l created_at, format: :short}"
    texto << "".ljust(32, '-')

    texto << "Folio:  #{folio.to_s.rjust(6, ' ')} Sucursal: #{sucursal.to_s.ljust(7, ' ')}"
    texto << "Mesero: #{mesero.to_s[0,5].rjust(6, ' ')} Comensales: #{comensales.to_s.rjust(5, ' ')}"

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

  def print_logo
    printer = Escpos::Printer.new
    path = Rails.root.join('app/assets/images/logo_bn.png').to_s
    image = Escpos::Image.new( path, { processor: 'ChunkyPng' })
    printer.write(image.to_escpos)

    File.open('/dev/usb/lp0', 'w:ascii-8bit') { |f| f.write(printer.to_escpos) }
  end

  def print_ticket
    print_logo
    File.open('/dev/usb/lp0', 'w:ascii-8bit') { |f| f.write(to_text) }
  end

  def monto_pagado
    unless pago == venta
      errors.add(:pago_con_efectivo, "La suma de los montos de pago debe ser: #{venta} y actualmente es: #{pago}")
    end
  end

  def set_folio
    max_folio = sucursal.comandas.maximum(:folio)
    self.folio = max_folio.to_i + 1
  end
end
