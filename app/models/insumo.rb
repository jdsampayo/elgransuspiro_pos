# == Schema Information
#
# Table name: insumos
#
#  id                   :uuid             not null, primary key
#  nombre               :string
#  cantidad_actual      :integer          default(0)
#  unidad               :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  paquete              :enum
#  cantidad_por_paquete :integer          default(0)
#

class Insumo < ApplicationRecord
  include Discard::Model

  self.discard_column = :deleted_at
	self.implicit_order_column = 'LOWER(nombre)'

  enum unidad: {gramo: "gramo", mililitro: "mililitro", pieza: "pieza"}, _prefix: true
  enum paquete: {caja: "caja", pieza: "pieza", kilo: "kilo", litro: "litro"}, _prefix: true

  def to_s
    nombre.titleize
  end
end
