Rails.application.routes.draw do
  resources :places, path: 'reservations'
  resources :aliances
  
  devise_for :users, path: '', only: :sessions

  devise_scope :user do
    authenticated :user do
      root 'dashboard#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end


  resources :users, only: [:index, :edit, :update] 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
