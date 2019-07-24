Rails.application.routes.draw do
  resources :alliance_membership_requests, only: [:create, :destroy] do 
    post "accept", on: :member
  end

  resources :places, path: 'reservations' do 
    post 'reservations/create'
    post 'reservations/create_for_alliance', on: :collection
    delete 'reservations/destroy'
  end

  resources :aliances do 
    post "remove_member", on: :member
  end
  
  devise_for :users, path: '', only: [:sessions, :password]

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
