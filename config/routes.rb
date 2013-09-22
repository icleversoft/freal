Freal::Application.routes.draw do

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
  end
end