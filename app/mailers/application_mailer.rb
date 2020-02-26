class ApplicationMailer < ActionMailer::Base
  default from: %('QnA' <qna@support.com>)
  layout 'mailer'
end
