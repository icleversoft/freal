Freal::Application.routes.draw do

  get "cities/index"

  get "stations/index"

  get "owners/index"

  authenticated :user do
    root :to => 'home#index'
  end
  
  root :to => "home#index"
  devise_for :users
  resources :users
  
  namespace :admin do
    resources :counties
    resources :municipalities do
      member do
        get :cities
      end
    end
    resources :cities
    match "all_stations" => "stations#index", :as => :all_stations
    match "all_owners" => "owners#index", :as => :all_owners
  end
  
  namespace :api do
    namespace :v1 do
      get '/counties'   => 'counties#all', format: :json
      get '/cities/all/:page'   => 'cities#all', format: :json, conditions: {page: /\d+/}
      get '/cities/find/:query' => 'cities#find_by_name', format: :json
      get '/cities/ac/:query' => 'cities#autocomplete', format: :json
      get '/county/:id/municipalities' => 'counties#municipalities', format: :json
      
      delete '/myfavorites/:token/:id' => 'cities#delete_favorite', format: :json
      
      match '/nearme'   => 'cities#nearme', format: :json
      get '/mystation/:token/:id' => 'cities#mystation', format: :json#, :constraints => {:token => /[0-9a-f]{64}/}
      get '/myfavorites/:token' => 'cities#myfavorites', format: :json#, :constraints => {:token => /[0-9a-f]{64}/}
      post '/register_device/:token' => 'registration#create', format: :json#, :constraints => {:token => /[0-9a-f]{64}/}
      post '/observe_station/:token/:station_id' => 'registration#observe_station', format: :json, :constraints => {:token => /[0-9a-f]{64}/}
    end  
  end
end