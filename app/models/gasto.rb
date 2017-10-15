class Gasto < ApplicationRecord
  validates_presence_of :monto, :descripcion

  scope :del_dia, ->(dia) do
    where(created_at: dia.beginning_of_day..dia.end_of_day) if dia
  end
end
