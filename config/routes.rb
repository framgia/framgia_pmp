Rails.application.routes.draw do
  devise_for :users, only: [:session, :password]
  root "projects#index"

  resources :sprints
  resources :projects
  resources :synchronizes, only: [:index, :create]

  namespace :api do
    resources :sprints
  end
  namespace :admin do
    root "projects#index"
    resources :projects do
      resources :sprints
    end
  end

  resources :synchronizes, only: [:index, :create]
  resources :users, except: [:new, :create]
end
