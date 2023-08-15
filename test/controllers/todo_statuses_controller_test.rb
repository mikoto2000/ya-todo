require "test_helper"

class TodoStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @todo_status = todo_statuses(:one)
  end

  test "should get index" do
    get todo_statuses_url
    assert_response :success
  end

  test "should get index find by id" do
    get todo_statuses_url, params: { q: { id_eq: @todo_status.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @todo_status.id.to_s
  end
  test "should get index search name" do
    search_string = @todo_status.name
    get todo_statuses_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: search_string # one
  end

  test "should get index search name, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get todo_statuses_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: todo_statuses(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: todo_statuses(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: todo_statuses(:destroy_target).name # destroy_target
  end

  test "should get index search created_at single hit" do
    target_datetime = @todo_status.created_at
    get todo_statuses_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = todo_statuses(:one).created_at
    target_datetime_to = todo_statuses(:two).created_at
    get todo_statuses_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @todo_status.updated_at
    get todo_statuses_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = todo_statuses(:one).updated_at
    target_datetime_to = todo_statuses(:two).updated_at
    get todo_statuses_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_todo_status_url
    assert_response :success
  end

  test "should create todo_status" do
    assert_difference("TodoStatus.count") do
      post todo_statuses_url, params: { todo_status: {
        name: @todo_status.name
      } }
    end

    assert_redirected_to todo_status_url(TodoStatus.last)
  end

  test "should show todo_status" do
    get todo_status_url(@todo_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_todo_status_url(@todo_status)
    assert_response :success
  end

  test "should update todo_status" do
    patch todo_status_url(@todo_status), params: { todo_status: {
      name: @todo_status.name
    } }
    assert_redirected_to todo_status_url(@todo_status)
  end

  test "should destroy todo_status" do
    todo_status = todo_statuses(:destroy_target)
    assert_difference("TodoStatus.count", -1) do
      delete todo_status_url(todo_status)
    end

    assert_redirected_to todo_statuses_url
  end
end
