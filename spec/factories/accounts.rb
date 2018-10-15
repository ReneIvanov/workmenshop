FactoryBot.define do
  factory :account do
    admin? false
    customer? false
    workmen? false
    user nil
  end
end
