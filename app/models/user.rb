class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_one :account, dependent: :delete
  has_and_belongs_to_many :works, dependent: :delete, touch: true

  has_one_attached :profile_picture #connection with ActiveStorage - now is possible to use user.profile_picture
  #has_many_attached :photos

  #validates :email, :username, presence: true
  #validates :username, uniqueness: true
  #validate :atleast_one_is_checked

  #add record in table users_works, if this record doesn't exist

  #update table users_works for current_user
  def update_existed_works(existed_works_id) 
    self.work_ids = existed_works_id
  end

  #return all works of user
  def user_works
    Rails.cache.fetch("#{self.id}_all_works") { puts 'Creating a cache'; self.works }   
  end

end
