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
  has_many :ordenes
  has_many :conteos
  has_many :insumos
  has_and_belongs_to_many :extras
  has_and_belongs_to_many :desechables
  belongs_to :categoria

  self.discard_column = :deleted_at
  self.implicit_order_column = Arel.sql('LOWER(nombre)')

  validates :nombre, presence: true

  def to_s
    nombre.titleize
  end

  def last_sale
    ordenes.last
  end

  def first_sale
    ordenes.first
  end

  def total
    ordenes.sum(:cantidad)
  end
end
