class Conteo < ApplicationRecord
  has_many :articulos
  has_many :cortes

  acts_as_paranoid
end
