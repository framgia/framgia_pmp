require "api_constraints"

Rails.application.routes.draw do
  devise_for :users, only: [:session, :password]
  root "projects#index"

  resources :sprints
  resources :synchronizes, only: [:index, :create]
  resource :product_backlog_updates

  resources :projects do
    resources :product_backlogs
  end
  
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

  namespace :api, defaults: {format: "json"} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :product_backlogs
    end
  end
end
