FactoryBot.define do
  factory :user do
    email { "MyString" }
    preferred_price_range { 1...2 }
  end
end
