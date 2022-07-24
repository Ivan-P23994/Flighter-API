FactoryBot.define do
  factory :booking do
    no_of_seats { rand(1..80) }
    seat_price { rand(50..1000) }
    user { association :user }
    flight { association :flight }
  end
end
