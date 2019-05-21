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
  belongs_to :extra
  belongs_to :orden

  acts_as_paranoid

  delegate :precio, to: :extra
  delegate :to_s, to: :extra
end
