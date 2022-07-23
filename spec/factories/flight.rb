FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "flight-#{n}" }
    departs_at { DateTime.now + 1.day }
    arrives_at { DateTime.now + 2.days }
    no_of_seats { rand(1..80) }
    base_price { rand(1..1000) }
    company { association :company }
  end
end
