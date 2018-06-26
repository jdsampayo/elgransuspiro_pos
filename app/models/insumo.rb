class Insumo < ApplicationRecord
  default_scope { order('LOWER(nombre)') }

  acts_as_paranoid

  enum unidad: {gramo: "gramo", mililitro: "mililitro", pieza: "pieza"}

  def to_s
    nombre.titleize
  end
end
