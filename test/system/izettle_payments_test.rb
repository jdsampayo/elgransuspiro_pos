require "application_system_test_case"

class IzettlePaymentsTest < ApplicationSystemTestCase
  setup do
    @izettle_payment = izettle_payments(:one)
  end

  test "visiting the index" do
    visit izettle_payments_url
    assert_selector "h1", text: "Izettle Payments"
  end

  test "creating a Izettle payment" do
    visit izettle_payments_url
    click_on "New Izettle Payment"

    fill_in "Amount", with: @izettle_payment.amount
    fill_in "Comanda", with: @izettle_payment.comanda_id
    fill_in "Payed at", with: @izettle_payment.payed_at
    fill_in "Transaction", with: @izettle_payment.transaction_id
    fill_in "Type", with: @izettle_payment.type
    click_on "Create Izettle payment"

    assert_text "Izettle payment was successfully created"
    click_on "Back"
  end

  test "updating a Izettle payment" do
    visit izettle_payments_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @izettle_payment.amount
    fill_in "Comanda", with: @izettle_payment.comanda_id
    fill_in "Payed at", with: @izettle_payment.payed_at
    fill_in "Transaction", with: @izettle_payment.transaction_id
    fill_in "Type", with: @izettle_payment.type
    click_on "Update Izettle payment"

    assert_text "Izettle payment was successfully updated"
    click_on "Back"
  end

  test "destroying a Izettle payment" do
    visit izettle_payments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Izettle payment was successfully destroyed"
  end
end
