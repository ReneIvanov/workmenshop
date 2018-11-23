FactoryBot.define do
  factory :work do
    title {Faker::Company.unique.profession}

    trait :with_users do
      transient do
        users_count { 2 }
      end

      after(:create) do |work, evaluator|
        create_list(:user, evaluator.users_count, works: [work])
      end
    end
  end
end
