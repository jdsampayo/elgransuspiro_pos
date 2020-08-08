# == Schema Information
#
# Table name: sucursales
#
#  id         :uuid             not null, primary key
#  nombre     :string
#  direccion  :text
#  telefono   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class SucursalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
