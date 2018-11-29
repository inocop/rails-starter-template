class ApplicationMailer < ActionMailer::Base
  default from: "#{AppConst::APP_NAME}<#{Rails.application.config.x.myconf[:mail_from]}>"
  layout 'mailer'
end
