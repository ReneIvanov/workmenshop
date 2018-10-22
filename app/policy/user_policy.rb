class UserPolicy
	
	def initialize(user_obj)
		@user_obj = user_obj
	end

	def is_admin
		if @user_obj.account.is_a? Account #if user has account
			@user_obj.account.admin == true
		else
			false
		end
	end

	def is_workmen
		if @user_obj.account.is_a? Account
			@user_obj.account.workmen == true
		else
			false
		end
	end

	def is_customer
		if @user_obj.account.is_a? Account
			@user_obj.account.customer == true
		else
			false
		end
	end

end