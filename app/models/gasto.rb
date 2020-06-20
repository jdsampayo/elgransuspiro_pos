# == Schema Information
#
# Table name: gastos
#
#  id          :uuid             not null, primary key
#  monto       :decimal(, )      default(0.0)
#  descripcion :text
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#  corte_id    :uuid
#

class Gasto < ApplicationRecord
  include Discard::Model

  validates_presence_of :monto, :descripcion
  belongs_to :corte

  self.discard_column = :deleted_at

  scope :del_dia, ->(dia) do
    where(created_at: dia.beginning_of_day..dia.end_of_day) if dia
  end
end
