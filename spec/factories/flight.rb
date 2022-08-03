FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "flight-#{n}" }
    departs_at { DateTime.now + 1.day }
    arrives_at { DateTime.now + 2.days }
    no_of_seats { rand(80..250) }
    base_price { rand(1..150) }
    company { association :company }
  end
end
