FactoryBot.define do
  factory :user, class: User do
    username { Faker::Internet.unique.username}
    email {"#{username}@domain.kom".downcase}
    address { Faker::Address.full_address}
    telephone { Faker::PhoneNumber.phone_number}
    password { Faker::Internet.password(4, 16)}
  end
end
