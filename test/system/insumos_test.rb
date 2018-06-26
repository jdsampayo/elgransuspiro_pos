require "application_system_test_case"

class InsumosTest < ApplicationSystemTestCase
  setup do
    @insumo = insumos(:one)
  end

  test "visiting the index" do
    visit insumos_url
    assert_selector "h1", text: "Insumos"
  end

  test "creating a Insumo" do
    visit insumos_url
    click_on "New Insumo"

    fill_in "Cantidad Actual", with: @insumo.cantidad_actual
    fill_in "Deleted At", with: @insumo.deleted_at
    fill_in "Nombre", with: @insumo.nombre
    fill_in "Unidad", with: @insumo.unidad
    click_on "Create Insumo"

    assert_text "Insumo was successfully created"
    click_on "Back"
  end

  test "updating a Insumo" do
    visit insumos_url
    click_on "Edit", match: :first

    fill_in "Cantidad Actual", with: @insumo.cantidad_actual
    fill_in "Deleted At", with: @insumo.deleted_at
    fill_in "Nombre", with: @insumo.nombre
    fill_in "Unidad", with: @insumo.unidad
    click_on "Update Insumo"

    assert_text "Insumo was successfully updated"
    click_on "Back"
  end

  test "destroying a Insumo" do
    visit insumos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Insumo was successfully destroyed"
  end
end
