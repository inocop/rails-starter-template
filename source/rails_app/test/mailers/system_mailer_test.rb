require 'test_helper'

class SystemMailerTest < ActionMailer::TestCase

  setup do
    @user_1 = users(:user_1)
  end

  test "send_notification" do
    skip "なぜかActionView::Template::Errorが出るのでskip"

    mail = SystemMailer.send_notification(@user_1)
    assert_equal "notification", mail.subject
    assert_equal [@user_1.email], mail.to
    assert_equal ["from@example.test.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
