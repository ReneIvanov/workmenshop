class UsersWork < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :work, touch: true
end
