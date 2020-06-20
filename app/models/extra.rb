# == Schema Information
#
# Table name: extras
#
#  id         :uuid             not null, primary key
#  nombre     :text
#  precio     :decimal(, )      default(0.0)
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class Extra < ApplicationRecord
  include Discard::Model

  has_and_belongs_to_many :ordenes
  has_and_belongs_to_many :articulos

  self.discard_column = :deleted_at

  def to_s
    nombre.titleize
  end
end
