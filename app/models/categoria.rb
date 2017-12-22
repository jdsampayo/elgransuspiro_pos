class Categoria < ApplicationRecord
  has_many :articulos

  default_scope { order(:nombre) }

  def to_s
    nombre
  end
end
