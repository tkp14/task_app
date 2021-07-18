Rails.application.routes.draw do
  root 'static_pages#home'
  get :about,       to: 'static_pages#about'
  get :help,        to: 'static_pages#help'
  get :signup,      to: 'users#new'
  get :login,       to: 'sessions#new'
  post :login,       to: 'sessions#create'
  delete :logout,       to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users
  resources :tasks
  resources :relationships, only: [:create, :destroy]
end
