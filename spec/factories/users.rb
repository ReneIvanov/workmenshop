FactoryBot.define do
  factory :user, class: User do
    username { Faker::Internet.unique.username}
    email {"#{username}@domain.kom".downcase}
    address { Faker::Address.full_address}
    telephone { Faker::PhoneNumber.phone_number}
    password { Faker::Internet.password(4, 16)}

    trait :with_profile_picture do
      #profile_picture { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test-image.png'), 'image/png') }
      profile_picture { FilesTestHelper.png }
    end

    trait :with_works do
      transient do
        works_count { 2 }
      end

      after(:create) do |user, evaluator|
        create_list(:work, evaluator.works_count, users: [user])
      end
    end

     trait :with_customer_account do
      after(:create) do |user|
        create(:customer_account_for_user, user_id: user.id)
      end
    end

    trait :with_workmen_account do
      after(:create) do |user|
        create(:workmen_account_for_user, user_id: user.id)
      end
    end

    trait :with_admin_account do
      after(:create) do |user|
        create(:admin_account_for_user, user_id: user.id)
      end
    end
  end
end
