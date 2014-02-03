Freal::Application.routes.draw do

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
end