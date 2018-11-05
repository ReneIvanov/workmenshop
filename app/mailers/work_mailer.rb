class WorkMailer < ApplicationMailer
  def created
    @message = "New work has been created!"
    mail to: "rene.ivanov@gmail.com", subject: 'Workmenshop - new work'
  end
end
