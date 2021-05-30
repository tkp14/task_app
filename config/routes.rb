Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get :about,       to: 'static_pages#about'
  get :help,        to: 'static_pages#help'
  get :signup,      to: 'users#new'
  resources :users
end
