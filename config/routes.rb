Rails.application.routes.draw do
  root 'static_pages#home'
  get :about,       to: 'static_pages#about'
  get :help,        to: 'static_pages#help'
  get :signup,      to: 'users#new'
  resources :users
  get :login,       to: 'sessions#new'
  get :login,       to: 'sessions#create'
  get :logout,       to: 'sessions#destroy'
end
