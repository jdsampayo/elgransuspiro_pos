class Extra < ApplicationRecord
  has_and_belongs_to_many :ordenes

  def to_s
    nombre
  end
end
