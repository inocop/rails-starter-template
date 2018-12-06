require "application_system_test_case"

class Users::SessionTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit "users/sign_in"

    assert_selector "h1", text: "Rails App"
  end

  test "user sign in" do
    user_2 = users(:user_2)
    project_2 = projects(:project_2)

    sign_in(user_2, project_2.id)

    assert_equal "/", page.current_path
    assert_equal project_2.name, page.find('select#project_id option[selected]').text
    assert page.first("#navbarDropdown").has_text?(user_2.name)
  end
end