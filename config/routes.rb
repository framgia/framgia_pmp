require "api_constraints"

Rails.application.routes.draw do
  devise_for :users, only: [:session, :password]
  root "projects#index"

  resources :synchronizes, only: [:index, :create]
  resources :columns, only: [:create]

  resources :projects do
    resources :product_backlogs
    resource :product_backlog_updates
    resources :sprints, only: [:show, :update] do
      resources :work_performances, except: [:new, :create]
    end
  end

  namespace :api do
    resources :sprints
  end

  namespace :admin do
    root "projects#index"
    resources :phases
    resources :projects do
      resources :sprints do
        resources :work_performances, except: [:new, :create]
        resources :time_logs, only: [:create]
      end
    end
  end

  resources :synchronizes, only: [:index, :create]
  resources :users, except: [:new, :create]
  namespace :api, defaults: {format: "json"} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :product_backlogs
    end
  end
  resources :invite_users
end
