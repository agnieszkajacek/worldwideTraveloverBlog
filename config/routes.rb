require 'sidekiq/web'

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

  # if Rails.env.development?
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  scope :monitoring do
    # Sidekiq Basic Auth from routes on production environment
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_AUTH_USERNAME"])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_AUTH_PASSWORD"]))
    end if Rails.env.production?

    mount Sidekiq::Web, at: '/sidekiq'
  end
end
