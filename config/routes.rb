Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants/search#search"
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "merchants/items" do
        end
      end

      get "/items/find_all", to: "items/search#search"
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], controller: "items/merchant"
      end
    end
  end
end
