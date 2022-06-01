FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    preferred_price_range { 1...2 }
  end

  trait :with_preferred_brands do
    after(:create) do |user|
      create_list(:user_preferred_brand, 2, user: user)
    end
  end
end
