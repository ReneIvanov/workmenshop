class ApplicationMailer < ActionMailer::Base
  default from: Workmenshop::Application.credentials[Rails.env.to_sym][:USERNAME]  #according which is Rails enviroment insert variable :USERNAME from config/credentials.yml.enc
  layout 'mailer'
end
