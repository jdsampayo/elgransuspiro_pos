class Comanda < ApplicationRecord
  belongs_to :corte
  belongs_to :mesero
  has_many :ordenes, inverse_of: :comanda
  has_many :articulos, through: :ordenes

  before_save :set_totales
  validates :descuento, :total, :venta, numericality: {greater_than_or_equal_to: 0}
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

  def cerrar
    self.closed_at = Time.now
    save
    actualizar_conteos
  end

  def actualizar_conteos
    ordenes.each do |orden|
      conteo = Conteo.where(articulo_id: orden.articulo.id, corte_id: corte.id).first_or_initialize
      conteo.total += orden.cantidad
      conteo.save

      orden.descontar_desechables
    end
  end

  def set_totales
    ordenes.map(&:guardar_precios_historicos)
    self.venta = ordenes.map(&:precio).sum
    self.total = venta - descuento
  end

  def to_s
    id
  end

  def abierta?
    closed_at.blank?
  end

  def to_text
    texto = []
    texto << "   #{I18n.l created_at, format: :short}"
    texto << ""

    texto << "Ticket: #{id.to_s.ljust(9, ' ')} Comensales: #{comensales.to_s.rjust(2, ' ')}"
    texto << "Mesa: #{mesa.ljust(11, ' ')} Mesero: #{mesero.to_s[0,5].rjust(6, ' ')}"

    texto << ""

    texto << " # Nombre            P/U  Precio"
    ordenes.each do |orden|
      texto << orden.to_text
      texto << "Extras: #{orden.extra_ordenes.join(', ')}" if orden.extra_ordenes.present?
    end

    texto << ""

    texto << "Subtotal:                  #{venta.to_s.rjust(5, ' ')}"
    texto << "Descuento:                 #{descuento.to_s.rjust(5, ' ')}"

    texto << "Total:                     #{total.to_s.rjust(5, ' ')}"

    texto << ""
    texto << ""
    texto << ""

    I18n.transliterate(texto.join("\r\n"))
  end


  def print_ticket
    logo = Escpos::Image.new(Rails.root.join('app/assets/images/logo_bn.png'))

    printer = Escpos::Printer.new

    #printer.write(Escpos.sequence(Escpos::IMAGE))
    #printer.write(logo.to_escpos)
    printer.write(Escpos.sequence(Escpos::TXT_NORMAL))
    printer.write(to_text)
    #printer.write(Escpos.sequence(Escpos::CD_KICK_2))

    ticket_file = Tempfile.new('ticket', encoding: 'ascii-8bit')
    ticket_file.write(printer.to_escpos)
    ticket_file.close
    `lpr -o raw -H localhost -P equal #{ticket_file.path}`
    sleep 1
    ticket_file.unlink
  end

end
