# == Schema Information
#
# Table name: cortes
#
#  id                 :uuid             not null, primary key
#  dia                :date
#  inicial            :decimal(, )      default(0.0)
#  ventas             :decimal(, )      default(0.0)
#  gastos             :decimal(, )      default(0.0)
#  total              :decimal(, )      default(0.0)
#  siguiente_dia      :decimal(, )      default(0.0)
#  sobre              :decimal(, )      default(0.0)
#  closed_at          :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  pagos_con_tarjeta  :decimal(, )      default(0.0)
#  pagos_con_efectivo :decimal(, )      default(0.0)
#  deleted_at         :datetime
#  propinas           :decimal(, )
#

require 'test_helper'

class CortesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @corte = cortes(:one)
  end

  test "should get index" do
    get cortes_url
    assert_response :success
  end

  test "should get new" do
    get new_corte_url
    assert_response :success
  end

  test "should create corte" do
    assert_difference('Corte.count') do
      post cortes_url, params: { corte: { dia: @corte.dia, gastos: @corte.gastos, inicial: @corte.inicial, siguiente_dia: @corte.siguiente_dia, sobre: @corte.sobre, total: @corte.total, ventas: @corte.ventas } }
    end

    assert_redirected_to corte_url(Corte.last)
  end

  test "should show corte" do
    get corte_url(@corte)
    assert_response :success
  end

  test "should get edit" do
    get edit_corte_url(@corte)
    assert_response :success
  end

  test "should update corte" do
    patch corte_url(@corte), params: { corte: { dia: @corte.dia, gastos: @corte.gastos, inicial: @corte.inicial, siguiente_dia: @corte.siguiente_dia, sobre: @corte.sobre, total: @corte.total, ventas: @corte.ventas } }
    assert_redirected_to corte_url(@corte)
  end

  test "should destroy corte" do
    assert_difference('Corte.count', -1) do
      delete corte_url(@corte)
    end

    assert_redirected_to cortes_url
  end
end
