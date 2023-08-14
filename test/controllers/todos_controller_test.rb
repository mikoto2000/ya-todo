require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @todo = todos(:one)
  end

  test "should get index" do
    get todos_url
    assert_response :success
  end

  test "should get index find by id" do
    get todos_url, params: { q: { id_eq: @todo.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @todo.id.to_s
  end
  test "should get index search name" do
    search_string = @todo.name
    get todos_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: search_string # one
  end

  test "should get index search name, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get todos_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: todos(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: todos(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: todos(:destroy_target).name # destroy_target
  end

  test "should get index search created_at single hit" do
    target_datetime = @todo.created_at
    get todos_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = todos(:one).created_at
    target_datetime_to = todos(:two).created_at
    get todos_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @todo.updated_at
    get todos_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = todos(:one).updated_at
    target_datetime_to = todos(:two).updated_at
    get todos_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_todo_url
    assert_response :success
  end

  test "should create todo" do
    assert_difference("Todo.count") do
      post todos_url, params: { todo: {
        name: @todo.name
      } }
    end

    assert_redirected_to todo_url(Todo.last)
  end

  test "should show todo" do
    get todo_url(@todo)
    assert_response :success
  end

  test "should get edit" do
    get edit_todo_url(@todo)
    assert_response :success
  end

  test "should update todo" do
    patch todo_url(@todo), params: { todo: {
      name: @todo.name
    } }
    assert_redirected_to todo_url(@todo)
  end

  test "should destroy todo" do
    todo = todos(:destroy_target)
    assert_difference("Todo.count", -1) do
      delete todo_url(todo)
    end

    assert_redirected_to todos_url
  end
end
