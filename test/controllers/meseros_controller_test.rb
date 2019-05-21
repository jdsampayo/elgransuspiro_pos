# == Schema Information
#
# Table name: meseros
#
#  id         :uuid             not null, primary key
#  nombre     :text
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

require 'test_helper'

class MeserosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mesero = meseros(:one)
  end

  test "should get index" do
    get meseros_url
    assert_response :success
  end

  test "should get new" do
    get new_mesero_url
    assert_response :success
  end

  test "should create mesero" do
    assert_difference('Mesero.count') do
      post meseros_url, params: { mesero: { nombre: @mesero.nombre } }
    end

    assert_redirected_to mesero_url(Mesero.last)
  end

  test "should show mesero" do
    get mesero_url(@mesero)
    assert_response :success
  end

  test "should get edit" do
    get edit_mesero_url(@mesero)
    assert_response :success
  end

  test "should update mesero" do
    patch mesero_url(@mesero), params: { mesero: { nombre: @mesero.nombre } }
    assert_redirected_to mesero_url(@mesero)
  end

  test "should destroy mesero" do
    assert_difference('Mesero.count', -1) do
      delete mesero_url(@mesero)
    end

    assert_redirected_to meseros_url
  end
end
