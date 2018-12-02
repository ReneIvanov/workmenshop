class LogedUserController < ApplicationController
  def wellcome
    if user_signed_in?
      respond_to do |format|
        format.html { render :wellcome }
        format.json { render json: { } }
      end
    else
      unauthorized
    end
  end
end
