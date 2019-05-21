# == Schema Information
#
# Table name: desechables
#
#  id             :uuid             not null, primary key
#  nombre         :text
#  en_bodega      :bigint(8)
#  cantidad       :bigint(8)
#  costo_unitario :decimal(, )
#  created_at     :datetime
#  updated_at     :datetime
#  limite         :bigint(8)
#  deleted_at     :datetime
#

require 'test_helper'

class DesechableTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
