Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'users/sessions'}
  root "posts#index"

  resources :posts
  resources :albums, only: [] do
    collection do
      get ':id(/:tag)', to: 'albums#show', as: 'show'
    end
  end
  resources :categories
  resources :photos
  resources :subscribers

  get '/kontakt', to: 'pages#kontakt'
  get '/wspolpraca', to: 'pages#wspolpraca'
  get '/polityka_prywatnosci', to: 'pages#polityka_prywatnosci'

  get 'subscribers/unsubscribe/:unsubscribe_hash', to: 'subscribers#unsubscribe', as: 'unsubscribe'
end
