class ApplicationController < ActionController::Base

	before_action :authorize_user
	before_action :authorize_admin

	protected

		def authorize_user
			unless Person.find_by(user_name: session[:user_name])
				redirect_to login_url, alert: "Please log in"
			end
		end

		def authorize_admin
			unless (Person.find_by(user_name: session[:user_name]) and session[:admin] == true)
				redirect_to login_url, alert: "Please log in"
			end
		end


end
