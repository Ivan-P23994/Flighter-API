Rails.application.routes.draw do
  root to: 'api/users#index'

  namespace :api do
    resources :session, only: [:create, :destroy]
    resources :users
    resources :bookings
    resources :flights
    resources :companies
  end
end
