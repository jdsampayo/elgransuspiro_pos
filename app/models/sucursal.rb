# == Schema Information
#
# Table name: sucursales
#
#  id         :uuid             not null, primary key
#  nombre     :string
#  direccion  :text
#  telefono   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Sucursal < ApplicationRecord
  has_many :cortes
  has_many :comandas, through: :cortes

  validates :nombre, uniqueness: true

  def to_s
    nombre.capitalize
  end

  def last_corte
    cortes.last
  end
end
