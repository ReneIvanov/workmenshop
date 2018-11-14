FactoryBot.define do
  factory :work do
    title {Faker::Company.unique.profession}
  end
end
