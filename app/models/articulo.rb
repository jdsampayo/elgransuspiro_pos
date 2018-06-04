class Articulo < ApplicationRecord
  has_many :comandas, through: :ordenes
  has_many :conteos
  has_and_belongs_to_many :desechables
  belongs_to :categoria

  accepts_nested_attributes_for :desechables

  default_scope { order('LOWER(nombre)') }

  acts_as_paranoid

  def to_s
    nombre.titleize
  end
end
