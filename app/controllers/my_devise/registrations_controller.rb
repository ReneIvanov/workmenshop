class MyDevise::RegistrationsController < Devise::RegistrationsController
	before_action :set_account_params, only: [:create]
	
	def create
		#byebug
		super
   		# add custom create logic here
	end
	
	protected
		def set_account_params
			@account_params = params[:account] #account part of parameters
			@user_params = params[:user] #user part of parameters
		end   
end  