class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
  
  has_one :account, dependent: :delete
  has_many :users_works, dependent: :delete_all
  has_many :works, through: :users_works

  has_one_attached :profile_picture, dependent: true  #connection with ActiveStorage - now is possible to use user.profile_picture
  
  validates :email, :username, presence: true
  validates :username, :email, uniqueness: true

  generate_public_uid generator: PublicUid::Generators::NumberSecureRandom.new(1000000..9999999) #from public_uid gem

  def self.find_param(param)   #methos to find record according public_uid
    find_by! public_uid: param
  end
  
  def to_param    #override rails method to_params - it meanst public_uid attribute will be used in urls instead of id attribute
    "#{public_uid}"
  end

  #update table users_works for current_user
  def update_existed_works(existed_works_id) 
    #self.work_ids = existed_works_id
    self.works = Work.where(id: existed_works_id)
    self.touch #update user's attribute "updated_at" (because cashing)
  end

  #return all works of user
  def user_works
    work_ids = Rails.cache.fetch("#{cache_key_with_version}/all_work_ids") { self.works.pluck(:id) } #here is used "cache_key_with_version" method, so the resulting cache_key will be something like "users/1/all_work_ids" but "cache_key_with_version" generates a string based on the model's `id` and `updated_at` attributes. This is a common convention and has the benefit of invalidating the cache whenever the product is updated.
    Work.where(id: work_ids)
  end
end
