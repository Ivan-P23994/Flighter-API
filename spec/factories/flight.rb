FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "flight-#{n}" }
    departs_at { DateTime.now + rand(1..99).years + rand(1..99).days }
    arrives_at { departs_at + 2.days }
    no_of_seats { rand(350..2250) }
    base_price { rand(1..150) }
    company { association :company }
  end

  def flight_with_bookings(bookings_count: 5)
    FactoryBot.create(:flight) do |flight|
      FactoryBot.create_list(:booking, bookings_count, flight: flight)
    end
  end
end
