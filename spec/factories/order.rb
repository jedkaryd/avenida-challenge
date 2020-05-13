FactoryBot.define do
  factory :order do
    client

    transient do 
      product { create(:product) }
    end

    after(:build) do |order, evaluator|
      order.products << evaluator.product
    end
  end
end
