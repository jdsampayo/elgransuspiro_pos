# == Schema Information
#
# Table name: insumos
#
#  id              :uuid             not null, primary key
#  nombre          :string
#  cantidad_actual :integer          default(0)
#  unidad          :string
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Insumo < ApplicationRecord
  default_scope { order('LOWER(nombre)') }

  acts_as_paranoid

  enum unidad: {gramo: "gramo", mililitro: "mililitro", pieza: "pieza"}, _prefix: true
  enum paquete: {caja: "caja", pieza: "pieza", kilo: "kilo", litro: "litro"}, _prefix: true

  def to_s
    nombre.titleize
  end
end
