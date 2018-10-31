class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_one :account, dependent: :delete
  has_and_belongs_to_many :works, dependent: :delete

  has_one_attached :profile_picture
  has_many_attached :photos

  #validates :email, :username, presence: true
  #validates :username, uniqueness: true
  #validate :atleast_one_is_checked

  #add record in table users_works, if this record doesn't exist
  def add_work(work)
    if self.works.include?(work)
      return false
    else
      self.works << work
      return true
    end
  end

  #update table users_works for current_user
  def update_existed_works(existed_works_id) 
    self.work_ids = existed_works_id
  end
end
