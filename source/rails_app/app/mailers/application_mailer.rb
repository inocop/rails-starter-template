class ApplicationMailer < ActionMailer::Base
  default from: AppConst::MAIL_FROM
  layout 'mailer'
end
