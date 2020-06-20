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
  include Discard::Model

  has_many :articulos

  default_scope { order(Arel.sql('LOWER(nombre)')) }

  self.discard_column = :deleted_at

  def to_s
    nombre
  end
end
