class Extra < ApplicationRecord
  has_and_belongs_to_many :ordenes

  acts_as_paranoid

  def to_s
    nombre
  end
end
