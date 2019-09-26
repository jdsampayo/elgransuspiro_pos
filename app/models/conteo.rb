# == Schema Information
#
# Table name: conteos
#
#  id          :uuid             not null, primary key
#  articulo_id :uuid
#  corte_id    :uuid
#  total       :bigint(8)        default(0)
#  deleted_at  :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

# Cantidad de articulos vendidos por corte y articulo

class Conteo < ApplicationRecord
  has_many :articulos
  has_many :cortes

  acts_as_paranoid

  def self.de_articulos
    group(:articulo_id).order('sum_total DESC').limit(10).sum(:total)
  end
end
