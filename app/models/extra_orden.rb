class ExtraOrden < ApplicationRecord
  belongs_to :extra
  belongs_to :orden

  acts_as_paranoid

  delegate :precio, to: :extra
  delegate :to_s, to: :extra
end
