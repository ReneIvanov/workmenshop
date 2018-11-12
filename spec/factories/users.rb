FactoryBot.define do 
#  factory :person1, class: Person do
#    name "Person1"
#    address "Address1"
#    workmen true
#    customer false
#    email "person1@gmail.com"
#    telephone "1111 111 111"
#    user_name "User1"
#    password "xxxx1"
#  end

  factory :user, class: User do
    sequence(:username, 1) { |n| "User#{n}" }
    sequence(:address, 1) { |n| "Address#{n}" }
#    workmen true
#    customer true
    sequence(:email, 1) { |n| "user#{n}@gmail.com" }
    telephone "1111 111 111"
#    sequence(:user_name, 1) { |n| "User#{n}" }
    password "xxxx"
  end
end
