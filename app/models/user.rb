class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

	has_one :account, dependent: :destroy
	accepts_nested_attributes_for :account
	
	has_one_attached :profile_picture
	has_many_attached :photos



	#validates :email, :username, presence: true
	#validates :username, uniqueness: true
	#validate :atleast_one_is_checked

  


	#def atleast_one_is_checked
    #	errors.add(:base, "Select atleast one output format type") unless workmen || customer
  	#end

end
