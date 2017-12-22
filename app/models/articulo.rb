class Articulo < ApplicationRecord
  has_many :comandas, through: :ordenes
  belongs_to :categoria

  default_scope { order('nombre ASC') }

  def to_s
    nombre.titleize
  end
end
