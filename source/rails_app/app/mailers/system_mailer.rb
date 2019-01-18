class SystemMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.system_mailer.send_notification.subject
  #
  def send_notification(user)
    @user = user
    @greeting = "Hi"

    return if @user.email.blank?

    mail(to: @user.email, subject: 'notification') do |format|
      format.html
      format.text
    end
  end

  # デベロッパーにエラーを通知
  def send_error(exception:)
    @message   = exception.message
    @backtrace = exception.backtrace.join("\n")

    to_emails = Rails.application.config.x.myconf.developer_emails.split(",")
    return if to_emails.blank?

    mail(to: to_emails, subject: 'エラーが発生しました') do |format|
      format.text
    end
  end
end
