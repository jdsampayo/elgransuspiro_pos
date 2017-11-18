class Articulo < ApplicationRecord
  has_many :comandas, through: :ordenes

  def to_s
    nombre.titleize
  end
end
