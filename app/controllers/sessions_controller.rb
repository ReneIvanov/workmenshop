class SessionsController < ApplicationController
  def new
  end

  def create
  	person = Person.find_by(user_name: params[:user_name])
  	if person.try(:authenticate, params[:password])
  		session[:person_id] = person.id
  		redirect_to loged_user_url
  	else
  		redirect_to login_url, alert: "Invalid user/password combination"
  	end
  end

  def destroy
  	session[:person_id] = nil
  	redirect_to root_url, notice: "You were loged out."
  end
end
