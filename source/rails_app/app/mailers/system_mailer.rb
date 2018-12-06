class SystemMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.system_mailer.send_notification.subject
  #
  def send_notification(user)
    @user = user
    @greeting = "Hi"

    mail(to: @user.email, subject: 'notification') do |format|
      format.html
      format.text
    end
  end
end
