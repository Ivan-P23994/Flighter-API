FactoryBot.define do
  factory :user do
    role { nil }
    sequence(:password) { |n| "password#{n}" }
    sequence(:email) { |n| "user-#{n}@email.com" }
    sequence(:first_name) { |n| "user#{n}" }
    sequence(:last_name) { |n| "useric#{n}" }
  end
end
