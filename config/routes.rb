require "api_constraints"

Rails.application.routes.draw do
  devise_for :users, only: [:session, :password]
  root "projects#index"

  resources :synchronizes, only: [:index, :create]
  resources :columns, only: [:create]
  resources :rows, only: [:create, :destroy]

  resources :projects, only: [:index, :show] do
    resources :product_backlogs
    resources :sprints, only: [:show, :update] do
      resources :work_performances
      patch "/work_performances", to: "work_performances#update"
    end
  end

  namespace :api do
    resources :projects do
      resources :sprints do
        resources :work_performances, only: [:index]
      end
    end
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

  resource :update_product_backlogs
  post "/ajax/check_work_performances", to: "check_work_performances#update"

  resources :synchronizes, only: [:index, :create]
  resources :users, except: [:new, :create]
  resources :invite_users
end
