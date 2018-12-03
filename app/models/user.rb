class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_one :account, dependent: :delete
  has_and_belongs_to_many :works, dependent: :delete, touch: true

  has_one_attached :profile_picture, dependent: true  #connection with ActiveStorage - now is possible to use user.profile_picture

  generate_public_uid column: :id, generator: PublicUid::Generators::NumberSecureRandom.new(1000000..9999999) #from public_uid gem

  validates :email, :username, presence: true
  validates :username, :email, uniqueness: true

  #update table users_works for current_user
  def update_existed_works(existed_works_id) 
    self.work_ids = existed_works_id
  end

  #return all works of user
  def user_works
    Rails.cache.fetch("#{cache_key}/all_works") { puts 'Creating a cache'; self.works }   
  end
end
