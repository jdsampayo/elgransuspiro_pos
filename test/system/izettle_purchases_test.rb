require "application_system_test_case"

class IzettlePurchasesTest < ApplicationSystemTestCase
  setup do
    @izettle_purchase = izettle_purchases(:one)
  end

  test "visiting the index" do
    visit izettle_purchases_url
    assert_selector "h1", text: "Izettle Purchases"
  end

  test "creating a Izettle purchase" do
    visit izettle_purchases_url
    click_on "New Izettle Purchase"

    fill_in "Amount", with: @izettle_purchase.amount
    fill_in "Cc brand", with: @izettle_purchase.cc_brand
    fill_in "Cc masked number", with: @izettle_purchase.cc_masked_number
    fill_in "Comanda id", with: @izettle_purchase.comanda_id_id
    fill_in "Id", with: @izettle_purchase.id
    fill_in "Purchased at", with: @izettle_purchase.purchased_at
    click_on "Create Izettle purchase"

    assert_text "Izettle purchase was successfully created"
    click_on "Back"
  end

  test "updating a Izettle purchase" do
    visit izettle_purchases_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @izettle_purchase.amount
    fill_in "Cc brand", with: @izettle_purchase.cc_brand
    fill_in "Cc masked number", with: @izettle_purchase.cc_masked_number
    fill_in "Comanda id", with: @izettle_purchase.comanda_id_id
    fill_in "Id", with: @izettle_purchase.id
    fill_in "Purchased at", with: @izettle_purchase.purchased_at
    click_on "Update Izettle purchase"

    assert_text "Izettle purchase was successfully updated"
    click_on "Back"
  end

  test "destroying a Izettle purchase" do
    visit izettle_purchases_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Izettle purchase was successfully destroyed"
  end
end
