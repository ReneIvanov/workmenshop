FactoryBot.define do
  factory :account_customer, class: Account do
    user_id {nil}
    customer {true}
    workmen {[true, false].sample}
    admin {nil}

    association :user, factory: :user, strategy: :build  #build a instance of User model and connect it with created account
  end

  factory :account_workmen, class: Account do
    user_id {nil}
    customer {[true, false].sample}
    workmen {true}
    admin {nil}

    association :user, factory: :user, strategy: :build  #build a instance of User model and connect it with created account
  end

  factory :account_admin, class: Account do
    user_id {nil}
    customer {nil}
    workmen {nil}
    admin {true}

    association :user, factory: :user, strategy: :build  #build a instance of User model and connect it with created account
  end

  #account for user without creation a new user(association)
  factory :workmen_account_for_user, class: Account do
    user_id {nil}
    customer {[true, false].sample}
    workmen {true}
    admin {nil}
  end
end
