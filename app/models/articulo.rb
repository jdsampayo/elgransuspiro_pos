# == Schema Information
#
# Table name: articulos
#
#  id           :uuid             not null, primary key
#  nombre       :text
#  precio       :decimal(, )      default(0.0)
#  created_at   :datetime
#  updated_at   :datetime
#  categoria_id :uuid
#  deleted_at   :datetime
#

class Articulo < ApplicationRecord
  include Discard::Model

  has_many :comandas, through: :ordenes
  has_many :conteos
  has_many :insumos
  has_and_belongs_to_many :extras
  has_and_belongs_to_many :desechables
  belongs_to :categoria

  default_scope { order(Arel.sql('LOWER(nombre)')) }

  self.discard_column = :deleted_at

  validates :nombre, presence: true

  def to_s
    nombre.titleize
  end
end
