require "application_system_test_case"

class TodoStatusesTest < ApplicationSystemTestCase
  setup do
    @todo_status = todo_statuses(:one)
  end

  test "visiting the index" do
    visit todo_statuses_url
    assert_selector "h1", text: "Todo statuses"
  end

  test "should create todo status" do
    visit todo_statuses_url
    click_on "New todo status"

    fill_in "Name", with: @todo_status.name
    click_on "Create Todo status"

    assert_text "Todo status was successfully created"
    click_on "Back"
  end

  test "should update Todo status" do
    visit todo_status_url(@todo_status)
    click_on "Edit this todo status", match: :first

    fill_in "Name", with: @todo_status.name
    click_on "Update Todo status"

    assert_text "Todo status was successfully updated"
    click_on "Back"
  end

  test "should destroy Todo status" do
    visit todo_status_url(@todo_status)
    click_on "Destroy this todo status", match: :first

    assert_text "Todo status was successfully destroyed"
  end
end
