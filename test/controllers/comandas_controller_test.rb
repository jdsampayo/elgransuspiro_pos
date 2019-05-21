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

class ComandasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comanda = comandas(:one)
  end

  test "should get index" do
    get comandas_url
    assert_response :success
  end

  test "should get new" do
    get new_comanda_url
    assert_response :success
  end

  test "should create comanda" do
    assert_difference('Comanda.count') do
      post comandas_url, params: { comanda: { descuento: @comanda.descuento, mesero_id: @comanda.mesero_id, total: @comanda.total } }
    end

    assert_redirected_to comanda_url(Comanda.last)
  end

  test "should show comanda" do
    get comanda_url(@comanda)
    assert_response :success
  end

  test "should get edit" do
    get edit_comanda_url(@comanda)
    assert_response :success
  end

  test "should update comanda" do
    patch comanda_url(@comanda), params: { comanda: { descuento: @comanda.descuento, mesero_id: @comanda.mesero_id, total: @comanda.total } }
    assert_redirected_to comanda_url(@comanda)
  end

  test "should destroy comanda" do
    assert_difference('Comanda.count', -1) do
      delete comanda_url(@comanda)
    end

    assert_redirected_to comandas_url
  end
end
