# == Schema Information
#
# Table name: comandas
#
#  id                      :uuid             not null, primary key
#  venta                   :decimal(, )      default(0.0)
#  descuento               :decimal(, )      default(0.0)
#  total                   :decimal(, )      default(0.0)
#  mesero_id               :uuid
#  deleted_at              :datetime
#  closed_at               :datetime
#  comensales              :bigint(8)        default(1)
#  mesa                    :text             default("PARA LLEVAR")
#  created_at              :datetime
#  updated_at              :datetime
#  pago_con_tarjeta        :boolean          default(FALSE)
#  corte_id                :uuid
#  propina                 :decimal(, )      default(0.0)
#  porcentaje_de_descuento :bigint(8)        default(0)
#

require 'test_helper'

class ComandaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
