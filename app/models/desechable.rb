class Desechable < ApplicationRecord
  acts_as_paranoid

  def to_s
    nombre
  end
end
