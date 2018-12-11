class Work < ApplicationRecord
  has_and_belongs_to_many :users, dependent: :delete, touch: true

  validates :title, presence: true, uniqueness: true

  generate_public_uid generator: PublicUid::Generators::NumberSecureRandom.new(1000000..9999999) #from public_uid gem

  def self.find_param(param)   #methos to find record according public_uid
    find_by! public_uid: param
  end
  
  def to_param    #override rails method to_params - it meanst public_uid attribute will be used in urls instead of id attribute
    "#{public_uid}"
  end

  #add record in table users_works, if this record doesn't exist
  def add_user(user)
    if self.users.include?(user)
      return false
    else
      self.users << user
      return true
    end
  end

  #return all users of work
  def work_users
    Rails.cache.fetch("#{cache_key}/all_users") { self.users }   
  end
end
