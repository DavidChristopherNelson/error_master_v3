require "application_system_test_case"

class DecoErrorsTest < ApplicationSystemTestCase
  setup do
    @deco_error = deco_errors(:one)
  end

  test "visiting the index" do
    visit deco_errors_url
    assert_selector "h1", text: "Deco Errors"
  end

  test "creating a Deco error" do
    visit deco_errors_url
    click_on "New Deco Error"

    click_on "Create Deco error"

    assert_text "Deco error was successfully created"
    click_on "Back"
  end

  test "updating a Deco error" do
    visit deco_errors_url
    click_on "Edit", match: :first

    click_on "Update Deco error"

    assert_text "Deco error was successfully updated"
    click_on "Back"
  end

  test "destroying a Deco error" do
    visit deco_errors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Deco error was successfully destroyed"
  end
end
