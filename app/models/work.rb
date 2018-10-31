class Work < ApplicationRecord
  has_and_belongs_to_many :users, dependent: :delete

  #add record in table users_works, if this record doesn't exist
  def add_user(user)
    if self.users.include?(user)
      return false
    else
      self.users << user
      return true
    end
  end
end
