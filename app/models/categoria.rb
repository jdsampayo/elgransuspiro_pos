# == Schema Information
#
# Table name: categorias
#
#  id         :uuid             not null, primary key
#  nombre     :text
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class Categoria < ApplicationRecord
  has_many :articulos

  default_scope { order(Arel.sql('LOWER(nombre)')) }

  acts_as_paranoid

  def to_s
    nombre
  end
end
