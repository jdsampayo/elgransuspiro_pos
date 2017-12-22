class Conteo < ApplicationRecord
  has_many :articulos
  has_many :cortes
end
