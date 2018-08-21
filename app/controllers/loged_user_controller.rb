class LogedUserController < ApplicationController
 
	skip_before_action :authorize_admin

  def wellcome
  end
end
