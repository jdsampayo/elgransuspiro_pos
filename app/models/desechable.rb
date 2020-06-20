# == Schema Information
#
# Table name: desechables
#
#  id             :uuid             not null, primary key
#  nombre         :text
#  en_bodega      :bigint(8)
#  cantidad       :bigint(8)
#  costo_unitario :decimal(, )
#  created_at     :datetime
#  updated_at     :datetime
#  limite         :bigint(8)
#  deleted_at     :datetime
#

class Desechable < ApplicationRecord
  include Discard::Model

  self.discard_column = :deleted_at

  def to_s
    nombre
  end
end
