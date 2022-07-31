Rails.application.routes.draw do
  root to: 'api/users#index'

  namespace :api do
    resource :session # , only: [:create, :destroy]
    resources :users, :bookings, :flights, :companies
  end
end
