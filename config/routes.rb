Rails.application.routes.draw do
  root 'breweries#index'
  resources :memberships
  resources :beer_clubs
  resources :users do
    post 'toggle_activity', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :places, only: [:index, :show]
  post 'places', to:'places#search'
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :styles, only: [:index]
  resource :session, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
