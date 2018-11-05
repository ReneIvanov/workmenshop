class WorkMailer < ApplicationMailer
  def created(email)
    @message = "New work has been created!"
    mail to: email, subject: 'Workmenshop - new work'
  end
end
