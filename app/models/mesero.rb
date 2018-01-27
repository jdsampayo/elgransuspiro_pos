class Mesero < ApplicationRecord
  has_many :comandas

  acts_as_paranoid

  def to_s
    nombre
  end
end
