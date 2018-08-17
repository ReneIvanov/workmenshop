class Person < ApplicationRecord

has_one_attached :profile_picture
has_many_attached :photos

validates :name, presence: true, uniqueness: true
has_secure_password


end
