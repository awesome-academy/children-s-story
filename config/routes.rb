Rails.application.routes.draw do
  get "/login",to: "sessions#new"
  get "/signup", to: "users#new"
  root to: "static_pages#home"
	get "/contact", to:"static_pages#contact"
	get "/about", to:"static_pages#about"
  post "login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :tales do
    resources :reviewtales
    collection do
      get "show_archived", to: "tales#show_archived"
    end
    member do
      put "update_status", to: "tales#update_status"
      get "preview", to: "tales#preview"
      get "newest", to: "tales#newest"
      get "many_follow", to: "tales#many_follow"
      get "many_favourite", to: "tales#many_favourite"
      get :followers
      get :favouriters
    end
  end
  resources :users do
    collection do
      get :following
      get :favouriting
    end
  end
  resources :requests do
    collection do
      get "show_seen", to: "requests#show_seen"
      get "show_not_seen", to: "show_not_seen"
    end
    member do
      put "update_status", to: "requests#update_status"
    end
  end
  resources :categories
  resources :authors
  resources :relationships, only: [:create, :destroy]
  resources :favourites, only: [:create, :destroy]
end
