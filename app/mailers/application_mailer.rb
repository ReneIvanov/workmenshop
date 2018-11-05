class ApplicationMailer < ActionMailer::Base
  default from: Workmenshop::Application.credentials.development[:GMAIL_USERNAME]
  layout 'mailer'
end
