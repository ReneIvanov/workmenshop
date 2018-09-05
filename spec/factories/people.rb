
FactoryBot.define do
=begin  
  factory :person1, class: Person do
    name "Person1"
    address "Address1"
    workmen true
    customer false
    email "person1@gmail.com"
    telephone "1111 111 111"
    user_name "User1"
    password "asdf1"
  end
=end
  factory :person, class: Person do
    sequence(:name, 1) { |n| "Person#{n}" }
    sequence(:address, 1) { |n| "Address#{n}" }
    workmen true
    customer true
    sequence(:email, 1) { |n| "person#{n}@gmail.com" }
    telephone "1111 111 111"
    sequence(:user_name, 1) { |n| "User#{n}" }
    password "asdf"
  end

end