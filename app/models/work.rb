class Work < ApplicationRecord
  has_and_belongs_to_many :users, dependent: :delete, touch: true

  generate_public_uid column: :id, generator: PublicUid::Generators::NumberSecureRandom.new(1000000..9999999) #from public_uid gem

  validates :title, presence: true, uniqueness: true

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
    Rails.cache.fetch("#{cache_key}/all_users") { puts 'Creating a cache'; self.users }   
  end
end
