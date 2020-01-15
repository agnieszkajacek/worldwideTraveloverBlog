Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'users/sessions'}
  root "posts#index"

  get '/sitemap.xml', to: redirect("https://s3.#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['AWS_BUCKET']}/sitemaps/sitemaps/sitemap.xml.gz", status: 301)

  #get '/pl/tags/europe.html'
  get '/en/gallery/malta.html', to: redirect('/albums/malta')
  #get '/en/tags/thailand.html', to: redirect('/categories/tajlandia')
  #get '/en/tags/bangkok.html'
  #get '/pl/tags/tenerife.html'
  get '/pl/tags/poland.html', to: redirect('/categories/polska')
  get '/pl/tags/italy.html', to: redirect('/categories/wlochy')
  #get '/en/tags/kazimierz_dolny.html', to: redirect('/posts/cudze-chwalicie-swego-nie-znacie-w-roli-glownej-kazimierz-dolny')
  get '/pl/tags/bergamo-milano.html', to: redirect('/posts/bergamo-i-milano')
  get '/pl/2017/04/19/chiang-mai.html', to: redirect('/posts/chiang-mai')
  get '/pl/2017/04/13/tajlandia-garsc-niezbednych-informacji.html', to: redirect('/posts/tajlandia-garsc-niezbednych-informacji')
  #get '/en/2017/04/13/thailand-hadful-of-necessary-information.html', to: redirect('/posts/tajlandia-garsc-niezbednych-informacji')
  #get '/en/2017/05/05/bangkok-city-of-angels.html', to: redirect('/posts/bangkok-miasto-aniolow')
  get '/pl/2017/03/27/malta-w-listopadzie-podstawowe-informacje.html', to: redirect('/posts/malta-w-listopadzie-podstawowe-informacje')

  resources :posts
  resources :albums, only: [] do
    collection do
      get ':id(/:tag)', to: 'albums#show', as: 'show'
    end
  end
  resources :categories
  resources :photos
  resources :subscribers, only: [:create]

  get '/kontakt', to: 'pages#kontakt'
  get '/wspolpraca', to: 'pages#wspolpraca'
  get '/polityka_prywatnosci', to: 'pages#polityka_prywatnosci'

  get 'subscribers/unsubscribe/:unsubscribe_hash', to: 'subscribers#unsubscribe', as: 'unsubscribe'

  authenticate :user, lambda {|user| user.role == 'admin' } do
    mount PgHero::Engine, at: "pgdashboard"
  end
end
