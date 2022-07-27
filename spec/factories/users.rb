FactoryBot.define do
  factory :user do
    sequence(:password) { |n| "password#{n}" }
    sequence(:email) { |n| "user-#{n}@email.com" }
    first_name { 'User' }
  end
end
