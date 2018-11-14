class Account < ApplicationRecord
  belongs_to :user

  validate :atleast_one_is_checked

  def atleast_one_is_checked
      errors.add(:base, "Select atleast one output format type") unless workmen || customer || admin
  end
end
