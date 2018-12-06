require 'test_helper'

class Authed::TicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:project_2)
    @user_2 = users(:user_2)
    @ticket = tickets(:ticket_1)

    sign_in(@user_2, @project.id)
  end

  test "should get index" do
    get tickets_url
    assert_response :success
  end

  test "should get new" do
    get new_ticket_url
    assert_response :success
  end

  test "should create ticket" do
    assert_difference('Ticket.count') do
      post tickets_url, params: { ticket: { name: "test", project_id: 2, assigned_user_id: @user_2.id } }
    end

    assert_redirected_to ticket_url(Ticket.last)
  end

  test "should show ticket" do
    get ticket_url(@ticket)
    assert_response :success
  end

  test "should get edit" do
    get edit_ticket_url(@ticket)
    assert_response :success
  end

  test "should update ticket" do
    patch ticket_url(@ticket), params: { ticket: { name: "test" } }
    assert_redirected_to ticket_url(@ticket)
  end

  test "should destroy ticket" do
    assert_difference('Ticket.where(deleted_at: nil).count', -1) do
      delete ticket_url(@ticket)
    end

    assert_redirected_to tickets_url
  end
end
