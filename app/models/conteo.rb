# == Schema Information
#
# Table name: conteos
#
#  id          :uuid             not null, primary key
#  articulo_id :uuid
#  corte_id    :uuid
#  total       :bigint           default(0)
#  deleted_at  :datetime
#

# Cantidad de articulos vendidos por corte y articulo

class Conteo < ApplicationRecord
  include Discard::Model

  has_many :articulos
  has_many :cortes

  self.discard_column = :deleted_at

  def self.de_articulos
    group(:articulo_id).order('sum_total DESC').limit(10).sum(:total)
  end
end
