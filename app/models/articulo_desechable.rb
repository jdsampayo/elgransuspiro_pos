class ArticuloDesechable < ApplicationRecord
  self.table_name = "articulos_desechables"

  has_many :articulos
  has_many :desechables
end
