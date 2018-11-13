class ApplicationMailer < ActionMailer::Base
  default from: "#{MyAppConst::APP_NAME}<#{Rails.application.config.x.myconf[:mail_from]}>"
  layout 'mailer'
end
