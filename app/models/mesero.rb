class Mesero < ApplicationRecord
  has_many :comandas

  def to_s
    nombre
  end
end
