class Account < ApplicationRecord
  belongs_to :user

  generate_public_uid generator: PublicUid::Generators::NumberSecureRandom.new(1000000..9999999) #from public_uid gem

  def self.find_param(param)   #methos to find record according public_uid
    find_by! public_uid: param
  end
  
  def to_param    #override rails method to_params - it meanst public_uid attribute will be used in urls instead of id attribute
    "#{public_uid}"
  end

  validate :atleast_one_is_checked

  def atleast_one_is_checked
      errors.add(:base, "Select atleast one output format type") unless workmen || customer || admin
  end
end
