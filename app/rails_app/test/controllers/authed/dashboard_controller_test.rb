require 'test_helper'

class Authed::DashboardControllerTest < ActionDispatch::IntegrationTest

  setup do
    user_2 = users(:user_2)
    sign_in(user_2)
  end

  test "should get index" do
    get dashboard_url
    assert_response :success
  end

end
