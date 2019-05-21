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
  has_many :comandas, through: :ordenes
  has_many :conteos
  has_many :insumos
  has_and_belongs_to_many :desechables
  belongs_to :categoria

  default_scope { order('LOWER(nombre)') }

  acts_as_paranoid

  def to_s
    nombre.titleize
  end

  def to_sync_json
    self.as_json.deep_merge(
      "articulo" => { "desechable_ids" => desechables&.pluck(:id) }
    ).to_json
  end
end
