Rails.application.routes.draw do
  root to: "dashboard#index"
  
  resources :places
  resources :aliances
  
  devise_for :users, path: '', only: :sessions

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
