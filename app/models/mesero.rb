class Mesero < ApplicationRecord
  has_many :comandas
  has_many :asistencias

  acts_as_paranoid

  def to_s
    nombre
  end
end
