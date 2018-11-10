class Work < ApplicationRecord
  has_and_belongs_to_many :users, dependent: :delete, touch: true

  def add_work(work)
    if self.works.include?(work)
      return false
    else
      self.works << work
      return true
    end
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
    Rails.cache.fetch("#{self.id}_all_users") { self.users }   
  end
end
