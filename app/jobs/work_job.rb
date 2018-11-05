class WorkJob < ApplicationJob
  queue_as :default #this is name of queue used for ExampleJob 

  def perform(email)
    WorkMailer.created(email).deliver_later
  end
end
