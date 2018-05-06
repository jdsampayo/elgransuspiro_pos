class Orden < ApplicationRecord
  belongs_to :articulo
  belongs_to :comanda
  has_many :extra_ordenes

  accepts_nested_attributes_for :extra_ordenes, reject_if: :all_blank, allow_destroy: true

  after_initialize :set_defaults

  before_save :guardar_precios_historicos

  scope :ordered, -> { includes(:articulo).order('articulos.nombre') }

  acts_as_paranoid

  def set_defaults
    self.para_llevar = true
  end

  def precio
    cantidad * precio_unitario
  end

  def precio_extras
    extra_ordenes.map(&:precio).sum
  end

  def guardar_precios_historicos
    self.precio_unitario = articulo.precio + precio_extras
  end

  def descontar_desechables
    return unless para_llevar?

    articulo.desechables.each do |desechable|
      desechable.update_attribute(:cantidad, desechable.cantidad - cantidad)
    end
  end

  def to_text
    cantidad.to_s.rjust(2, ' ') + " " +
    articulo.to_s.upcase[0,16].ljust(17, '.') +
    precio_unitario.to_s.rjust(5, '.').ljust(7, ' ') +
    precio.to_s.rjust(5, ' ').ljust(5, ' ')
  end

  def to_s
    ((cantidad > 1) ? "(#{cantidad}) " : "") + articulo.to_s
  end
end
