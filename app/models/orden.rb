class Orden < ApplicationRecord
  belongs_to :articulo
  belongs_to :comanda
  has_many :extra_ordenes

  accepts_nested_attributes_for :extra_ordenes, reject_if: :all_blank, allow_destroy: true

  before_save :guardar_precios_historicos
  #after_commit :descontar_desechables

  scope :ordered, -> { includes(:articulo).order('articulos.nombre') }

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
    puts "**********************"
    puts articulo
    articulo.desechables.each do |desechable|
      puts "descontando #{desechable.cantidad}: #{cantidad}"
      desechable.update_attribute(:cantidad, desechable.cantidad - cantidad)
      desechable.reload
      puts "nuevo #{desechable.cantidad}"
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
