class Categoria < ApplicationRecord
  has_many :articulos

  default_scope { order(:nombre) }

  acts_as_paranoid

  def to_s
    nombre
  end
end
