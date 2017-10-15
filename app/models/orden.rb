class Orden < ApplicationRecord
  belongs_to :articulo
  belongs_to :comanda
  has_many :extra_ordenes

  accepts_nested_attributes_for :extra_ordenes, reject_if: :all_blank, allow_destroy: true

  before_save :guardar_precios_historicos

  def precio
    cantidad * precio_unitario
  end

  def precio_extras
    extra_ordenes.map(&:precio).sum
  end

  def guardar_precios_historicos
    self.precio_unitario = articulo.precio + precio_extras
  end
end
