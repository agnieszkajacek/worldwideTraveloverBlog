Rails.application.routes.draw do
  get 'subscribers/index'
  devise_for :users, controllers: {sessions: 'users/sessions'}
  root "posts#index"

  resources :posts
  resources :albums, only: [:show]
  resources :categories
  resources :photos
  resources :subscribers
end
