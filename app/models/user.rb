class User < ApplicationRecord

	has_one :account, dependent: :destroy
	has_one_attached :profile_picture
	has_many_attached :photos
	has_secure_password


	validates :name, :email, :user_name, presence: true
	validates :user_name, uniqueness: true
	validate :atleast_one_is_checked

  


	def atleast_one_is_checked
    	errors.add(:base, "Select atleast one output format type") unless workmen || customer
  	end

end
