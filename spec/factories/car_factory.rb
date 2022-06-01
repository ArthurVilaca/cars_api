FactoryBot.define do
  factory :car do
    model { Faker::Name.unique.name }
    price { 1 }
    brand { create(:brand) }
  end
end
