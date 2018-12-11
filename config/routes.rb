Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'users/sessions'}
  root "posts#index"

  resources :posts
  resources :albums, only: [:show]
  resources :categories
  resources :photos
  resources :subscribers

  get '/kontakt', to: 'pages#kontakt'
  get '/wspolpraca', to: 'pages#wspolpraca'

  get 'subscribers/unsubscribe/:unsubscribe_hash', to: 'subscribers#unsubscribe', as: 'unsubscribe'
end
