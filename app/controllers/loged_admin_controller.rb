class LogedAdminController < ApplicationController
  def wellcome
    if user_signed_in? && policy(current_user).is_admin
      respond_to do |format|
        format.html { render :wellcome }
        format.json { render json: { } }
      end
    else
      unauthorized
    end
  end
end
