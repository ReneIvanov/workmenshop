class UserPolicy < ApplicationPolicy
	
	def initialize(user_obj)
		@user_obj = user_obj
	end

	def has_account
		@user_obj.account.is_a? Account #if user has account
	end
	
	def is_admin
		if has_account
			@user_obj.account.admin == true
		else
			false
		end
	end

	def is_workmen
		if has_account
			@user_obj.account.workmen == true
		else
			false
		end
	end

	def is_customer
		if has_account
			@user_obj.account.customer == true
		else
			false
		end
	end

end