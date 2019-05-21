# == Schema Information
#
# Table name: meseros
#
#  id         :uuid             not null, primary key
#  nombre     :text
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class Mesero < ApplicationRecord
  has_many :comandas
  has_many :asistencias

  acts_as_paranoid

  def to_s
    nombre
  end
end
