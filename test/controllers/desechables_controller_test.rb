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

class DesechablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @desechable = desechables(:one)
  end

  test "should get index" do
    get desechables_url
    assert_response :success
  end

  test "should get new" do
    get new_desechable_url
    assert_response :success
  end

  test "should create desechable" do
    assert_difference('Desechable.count') do
      post desechables_url, params: { desechable: { costo: @desechable.costo, nombre: @desechable.nombre, unidad: @desechable.unidad } }
    end

    assert_redirected_to desechable_url(Desechable.last)
  end

  test "should show desechable" do
    get desechable_url(@desechable)
    assert_response :success
  end

  test "should get edit" do
    get edit_desechable_url(@desechable)
    assert_response :success
  end

  test "should update desechable" do
    patch desechable_url(@desechable), params: { desechable: { costo: @desechable.costo, nombre: @desechable.nombre, unidad: @desechable.unidad } }
    assert_redirected_to desechable_url(@desechable)
  end

  test "should destroy desechable" do
    assert_difference('Desechable.count', -1) do
      delete desechable_url(@desechable)
    end

    assert_redirected_to desechables_url
  end
end
