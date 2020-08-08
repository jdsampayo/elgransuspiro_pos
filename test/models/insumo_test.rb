# == Schema Information
#
# Table name: insumos
#
#  id                   :uuid             not null, primary key
#  nombre               :string
#  cantidad_actual      :integer          default(0)
#  unidad               :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  paquete              :enum
#  cantidad_por_paquete :integer          default(0)
#

require 'test_helper'

class InsumoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
