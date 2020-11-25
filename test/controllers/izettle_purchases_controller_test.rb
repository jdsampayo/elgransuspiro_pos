require 'test_helper'

class IzettlePurchasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @izettle_purchase = izettle_purchases(:one)
  end

  test "should get index" do
    get izettle_purchases_url
    assert_response :success
  end

  test "should get new" do
    get new_izettle_purchase_url
    assert_response :success
  end

  test "should create izettle_purchase" do
    assert_difference('IzettlePurchase.count') do
      post izettle_purchases_url, params: { izettle_purchase: { amount: @izettle_purchase.amount, cc_brand: @izettle_purchase.cc_brand, cc_masked_number: @izettle_purchase.cc_masked_number, comanda_id_id: @izettle_purchase.comanda_id_id, id: @izettle_purchase.id, purchased_at: @izettle_purchase.purchased_at } }
    end

    assert_redirected_to izettle_purchase_url(IzettlePurchase.last)
  end

  test "should show izettle_purchase" do
    get izettle_purchase_url(@izettle_purchase)
    assert_response :success
  end

  test "should get edit" do
    get edit_izettle_purchase_url(@izettle_purchase)
    assert_response :success
  end

  test "should update izettle_purchase" do
    patch izettle_purchase_url(@izettle_purchase), params: { izettle_purchase: { amount: @izettle_purchase.amount, cc_brand: @izettle_purchase.cc_brand, cc_masked_number: @izettle_purchase.cc_masked_number, comanda_id_id: @izettle_purchase.comanda_id_id, id: @izettle_purchase.id, purchased_at: @izettle_purchase.purchased_at } }
    assert_redirected_to izettle_purchase_url(@izettle_purchase)
  end

  test "should destroy izettle_purchase" do
    assert_difference('IzettlePurchase.count', -1) do
      delete izettle_purchase_url(@izettle_purchase)
    end

    assert_redirected_to izettle_purchases_url
  end
end
