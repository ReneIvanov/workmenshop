class ApplicationController < ActionController::Base
	#before_action :authenticate_user!
	
	#before_action :authorize_user
	#before_action :authorize_admin
	before_action :basic_rights

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

		def set_current_user
    		if current_user == nil
    			def current_user
    				return User.new
    			end
    		end
    	end

		def policy(object)
			@object_string = object.class.name 			#string = name of object class
			@object_policy_string = @object_string << "Policy"	#string = name of policy class 
			@object_policy_const = Object.const_get(@object_policy_string)	#constance of policy class
		
			@object_policy = @object_policy_const.new(object)	#return policy object (e.g. if claas of object in argument is "User", this action returm object of UserPolicy)
		end

		def basic_rights	#set some basic informations for views about user rights in order to display some kind of data. 
			if user_signed_in?	#if is current_user sign in
				@is_admin = policy(current_user).is_admin
				@is_workmen = policy(current_user).is_workmen
				@is_customer = policy(current_user).is_customer
				@is_account = current_user.account.is_a? Account #has current user account?
			end
			
		end
end