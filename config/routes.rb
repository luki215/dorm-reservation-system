Rails.application.routes.draw do
  resources :places
  resources :users
  resources :aliances
  devise_for :users, only: :sessions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"
end
