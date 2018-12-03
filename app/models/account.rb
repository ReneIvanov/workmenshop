class Account < ApplicationRecord
  belongs_to :user

  generate_public_uid column: :id, generator: PublicUid::Generators::NumberSecureRandom.new(1000000..9999999) #from public_uid gem

  validate :atleast_one_is_checked

  def atleast_one_is_checked
      errors.add(:base, "Select atleast one output format type") unless workmen || customer || admin
  end
end
