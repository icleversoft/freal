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
      match '/nearme'   => 'cities#index', format: :json
      post '/register_device/:token' => 'registration#create', format: :json
      post '/observe_station/:token/:station_id' => 'registration#observe_station', format: :json
    end  
  end
end