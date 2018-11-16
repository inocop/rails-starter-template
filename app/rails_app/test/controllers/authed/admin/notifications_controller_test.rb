require 'test_helper'

class Authed::Admin::NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_notification = admin_notifications(:one)
  end

  test "should get index" do
    get admin_notifications_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_notification_url
    assert_response :success
  end

  test "should create admin_notification" do
    assert_difference('Authed::Admin::Notification.count') do
      post admin_notifications_url, params: { admin_notification: {  } }
    end

    assert_redirected_to admin_notification_url(Authed::Admin::Notification.last)
  end

  test "should show admin_notification" do
    get admin_notification_url(@admin_notification)
    assert_response :success
  end

  test "should destroy admin_notification" do
    assert_difference('Authed::Admin::Notification.count', -1) do
      delete admin_notification_url(@admin_notification)
    end

    assert_redirected_to admin_notifications_url
  end
end
