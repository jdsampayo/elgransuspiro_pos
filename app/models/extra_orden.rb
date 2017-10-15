class ExtraOrden < ApplicationRecord
  belongs_to :extra
  belongs_to :orden

  delegate :precio, to: :extra
  delegate :to_s, to: :extra
end
