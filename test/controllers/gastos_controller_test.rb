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

class GastosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gasto = gastos(:one)
  end

  test "should get index" do
    get gastos_url
    assert_response :success
  end

  test "should get new" do
    get new_gasto_url
    assert_response :success
  end

  test "should create gasto" do
    assert_difference('Gasto.count') do
      post gastos_url, params: { gasto: { descripcion: @gasto.descripcion, monto: @gasto.monto } }
    end

    assert_redirected_to gasto_url(Gasto.last)
  end

  test "should show gasto" do
    get gasto_url(@gasto)
    assert_response :success
  end

  test "should get edit" do
    get edit_gasto_url(@gasto)
    assert_response :success
  end

  test "should update gasto" do
    patch gasto_url(@gasto), params: { gasto: { descripcion: @gasto.descripcion, monto: @gasto.monto } }
    assert_redirected_to gasto_url(@gasto)
  end

  test "should destroy gasto" do
    assert_difference('Gasto.count', -1) do
      delete gasto_url(@gasto)
    end

    assert_redirected_to gastos_url
  end
end
