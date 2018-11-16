# Preview all emails at http://localhost:3000/rails/mailers/system_mailer
class SystemMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/system_mailer/send_notification
  def send_notification
    SystemMailer.send_notification
  end

end
