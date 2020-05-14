FactoryBot.define do
  factory :client do
    email         { Faker::Internet.safe_email }
    name          { Faker::Name.name }
    dni           { Faker::Number.number(digits: 6) }
    phone_number  { Faker::PhoneNumber.cell_phone }
    address       { Faker::Address.street_address }
  end
end
