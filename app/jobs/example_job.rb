class ExampleJob < ApplicationJob
  queue_as :default #this is name of queue used for ExampleJob 

  def perform  
    sleep 1
    puts " joooo"
  end
end