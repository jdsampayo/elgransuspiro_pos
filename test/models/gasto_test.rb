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

require 'test_helper'

class GastoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
