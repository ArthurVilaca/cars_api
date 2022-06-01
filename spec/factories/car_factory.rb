FactoryBot.define do
  factory :car do
    model { Faker::Name.unique.name }
    price { 0.5 }
    brand { create(:brand) }
  end
end
