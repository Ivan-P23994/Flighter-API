FactoryBot.define do
  factory :user do
    role { nil }
    sequence(:password) { |n| "password#{n}" }
    sequence(:email) { |n| "user-#{n}@email.com" }
    first_name { 'User' }
  end
end
