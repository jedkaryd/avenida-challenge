FactoryBot.define do
  factory :product do
    title       { Faker::Commerce.product_name }
    description { Faker::Commerce.color }
    price       { Faker::Commerce.price }
    stock       { Faker::Number.number(digits: 6) }
    state       { 'visible' }
  end
end
