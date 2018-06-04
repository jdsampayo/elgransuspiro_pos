class Articulo < ApplicationRecord
  include Syncronize

  has_many :comandas, through: :ordenes
  has_many :conteos
  has_and_belongs_to_many :desechables
  belongs_to :categoria

  default_scope { order('nombre ASC') }

  acts_as_paranoid

  def to_s
    nombre.titleize
  end
end
