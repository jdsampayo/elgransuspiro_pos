require 'test_helper'

class ConteosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conteo = conteos(:one)
  end

  test "should get index" do
    get conteos_url
    assert_response :success
  end

  test "should get new" do
    get new_conteo_url
    assert_response :success
  end

  test "should create conteo" do
    assert_difference('Conteo.count') do
      post conteos_url, params: { conteo: { articulo_id: @conteo.articulo_id, corte_id: @conteo.corte_id, total: @conteo.total } }
    end

    assert_redirected_to conteo_url(Conteo.last)
  end

  test "should show conteo" do
    get conteo_url(@conteo)
    assert_response :success
  end

  test "should get edit" do
    get edit_conteo_url(@conteo)
    assert_response :success
  end

  test "should update conteo" do
    patch conteo_url(@conteo), params: { conteo: { articulo_id: @conteo.articulo_id, corte_id: @conteo.corte_id, total: @conteo.total } }
    assert_redirected_to conteo_url(@conteo)
  end

  test "should destroy conteo" do
    assert_difference('Conteo.count', -1) do
      delete conteo_url(@conteo)
    end

    assert_redirected_to conteos_url
  end
end
