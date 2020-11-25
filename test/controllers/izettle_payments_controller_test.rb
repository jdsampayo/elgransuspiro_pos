require 'test_helper'

class IzettlePaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @izettle_payment = izettle_payments(:one)
  end

  test "should get index" do
    get izettle_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_izettle_payment_url
    assert_response :success
  end

  test "should create izettle_payment" do
    assert_difference('IzettlePayment.count') do
      post izettle_payments_url, params: { izettle_payment: { amount: @izettle_payment.amount, comanda_id: @izettle_payment.comanda_id, payed_at: @izettle_payment.payed_at, transaction_id: @izettle_payment.transaction_id, type: @izettle_payment.type } }
    end

    assert_redirected_to izettle_payment_url(IzettlePayment.last)
  end

  test "should show izettle_payment" do
    get izettle_payment_url(@izettle_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_izettle_payment_url(@izettle_payment)
    assert_response :success
  end

  test "should update izettle_payment" do
    patch izettle_payment_url(@izettle_payment), params: { izettle_payment: { amount: @izettle_payment.amount, comanda_id: @izettle_payment.comanda_id, payed_at: @izettle_payment.payed_at, transaction_id: @izettle_payment.transaction_id, type: @izettle_payment.type } }
    assert_redirected_to izettle_payment_url(@izettle_payment)
  end

  test "should destroy izettle_payment" do
    assert_difference('IzettlePayment.count', -1) do
      delete izettle_payment_url(@izettle_payment)
    end

    assert_redirected_to izettle_payments_url
  end
end
