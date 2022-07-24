Rails.application.routes.draw do
  root to: 'api/users#index'

  namespace :api do
    resources :users
    resources :bookings
    resources :flights
    resources :companies
  end
end
