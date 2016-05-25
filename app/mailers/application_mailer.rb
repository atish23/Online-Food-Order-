class ApplicationMailer < ActionMailer::Base
  default from: "from@bad.com"
  layout 'mailer'
end
