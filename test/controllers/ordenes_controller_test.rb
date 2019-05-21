# == Schema Information
#
# Table name: ordenes
#
#  id              :uuid             not null, primary key
#  articulo_id     :uuid
#  comanda_id      :uuid
#  cantidad        :bigint(8)
#  precio_unitario :decimal(, )      default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#  para_llevar     :boolean
#  deleted_at      :datetime
#

require 'test_helper'

class OrdenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @orden = ordenes(:one)
  end

  test "should get index" do
    get ordenes_url
    assert_response :success
  end

  test "should get new" do
    get new_orden_url
    assert_response :success
  end

  test "should create orden" do
    assert_difference('Orden.count') do
      post ordenes_url, params: { orden: { articulo_id: @orden.articulo_id, cantidad: @orden.cantidad, comanda_id: @orden.comanda_id } }
    end

    assert_redirected_to orden_url(Orden.last)
  end

  test "should show orden" do
    get orden_url(@orden)
    assert_response :success
  end

  test "should get edit" do
    get edit_orden_url(@orden)
    assert_response :success
  end

  test "should update orden" do
    patch orden_url(@orden), params: { orden: { articulo_id: @orden.articulo_id, cantidad: @orden.cantidad, comanda_id: @orden.comanda_id } }
    assert_redirected_to orden_url(@orden)
  end

  test "should destroy orden" do
    assert_difference('Orden.count', -1) do
      delete orden_url(@orden)
    end

    assert_redirected_to ordenes_url
  end
end
