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
  resources :tasks
  resources :relationships, only: [:create, :destroy]
  get :favorites, to: 'favorites#index'
  post   "favorites/:task_id/create"  => "favorites#create"
  delete "favorites/:task_id/destroy" => "favorites#destroy"
  resources :comments, only: [:create, :destroy]
  resources :notifications, only: :index
  get :lists, to: 'lists#index'
  post   "lists/:task_id/create"  => "lists#create"
  delete "lists/:list_id/destroy" => "lists#destroy"
end
