FactoryBot.define do
  factory :car do
    model { "MyString" }
    price { 1 }
    brand { create(:brand) }
  end
end
