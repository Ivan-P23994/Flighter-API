Rails.application.routes.draw do
  root to: 'api/users#index'

  namespace :api do
    resources :sessions, only: [:create, :destroy]
    # get    'login'   => 'sessions#new'
    # post   'login'   => 'sessions#create'
    # delete 'logout'  => 'sessions#destroy'
    resources :users
    resources :bookings
    resources :flights
    resources :companies
  end
end
