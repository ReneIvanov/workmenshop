class SessionsController < ApplicationController

  skip_before_action :authorize_admin, only: [:new, :create, :destroy]
  skip_before_action :authorize_user

  def new
  end

  def create
  	person = Person.find_by(user_name: params[:user_name])
    if person.try(:authenticate, params[:password])
  		session[:user_name] = person.user_name
  		if person.user_name == "admin"
  			session[:admin] = true
  			redirect_to loged_admin_url
  		else 
  			session[:admin] = false
  			redirect_to loged_user_url
  		end
  	else
  		redirect_to login_url, alert: "Invalid user/password combination"
  	end
  end

  def destroy
  	session[:user_name] = nil
  	session[:admin] = false
  	redirect_to root_url, notice: "You were loged out."
  end


end
