# == Schema Information
#
# Table name: articulos_desechables
#
#  articulo_id   :uuid
#  desechable_id :uuid
#  id            :uuid             not null, primary key
#

class ArticuloDesechable < ApplicationRecord
  self.table_name = "articulos_desechables"

  has_many :articulos
  has_many :desechables
end
