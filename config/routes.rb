Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get :signup,       to: 'users#new'
  get :about,        to: 'static_pages#about'
  get :use_of_terms, to: 'static_pages#terms'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :apps
  get    :login,     to: 'sessions#new'
  post   :login,     to: 'sessions#create'
  delete :logout,    to: 'sessions#destroy'
  resources :relationships, only: [:create, :destroy]
  post   "favorites/:app_id/create"  => "favorites#create"
  delete "favorites/:app_id/destroy" => "favorites#destroy"
end
