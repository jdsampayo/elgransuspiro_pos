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

  validates :nombre, uniqueness: true

  def to_s
    nombre.capitalize
  end
end
