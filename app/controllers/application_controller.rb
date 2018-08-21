class ApplicationController < ActionController::Base

	before_action :authorize_user
	before_action :authorize_admin

	protected

		def authorize_user
			unless Person.find_by(id: session[:person_id])
				redirect_to login_url, alert: "Please log in"
			end
		end

		def authorize_admin
			unless (Person.find_by(id: session[:person_id]) and session[:admin] == true)
				redirect_to login_url, alert: "Please log in"
			end
		end


end
