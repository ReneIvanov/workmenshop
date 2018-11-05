class WorkJob < ApplicationJob
  queue_as :default #this is name of queue used for ExampleJob 

  def perform  
    sleep 1
    #WorkMailer.created
    puts "This is result from WorkJob!!!"
  end
end