class Articulo < ApplicationRecord
  has_many :comandas, through: :ordenes

  def to_s
    nombre
  end
end
