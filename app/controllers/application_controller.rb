class ApplicationController < ActionController::Base

	#before_action :authorize_user
	#before_action :authorize_admin

	before_action :configure_permitted_parameters, if: :devise_controller?  #because we want to add parameters to user = devise

	protected

  		def configure_permitted_parameters #descripted on https://github.com/plataformatec/devise
    		devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :address, :telephone]) #allows parameters for sign_up action (keys in devise.rb are permited by default)
  			devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :address, :telephone]) #allows parameters for sign_in action (keys in devise.rb are permited by default)
			devise_parameter_sanitizer.permit(:account_update, keys: [:username, :address, :telephone]) #allows parameters for account_update action (keys in devise.rb are permited by default)
  		end

  		#def after_sign_in_path_for(resource)
  		#	after_sign_in_path_for(resource) if is_navigational_format?
		#end

		def after_sign_out_path_for(resource_or_scope)
  			root_path
		end


		#def authorize_user
		#	unless User.find_by(user_name: session[:user_name])
		#		redirect_to login_url, alert: "Please log in"
		#	end
		#end

		#def authorize_admin
		#	unless (User.find_by(user_name: session[:user_name]) and session[:admin] == true)
		#		redirect_to login_url, alert: "Please log in"
		#	end
		#end

end
