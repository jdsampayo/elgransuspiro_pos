# == Schema Information
#
# Table name: extra_ordenes
#
#  id         :uuid             not null, primary key
#  extra_id   :uuid
#  orden_id   :uuid
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class ExtraOrden < ApplicationRecord
  include Discard::Model

  belongs_to :extra
  belongs_to :orden

  self.discard_column = :deleted_at

  delegate :precio, to: :extra
  delegate :to_s, to: :extra
end
