require "api_constraints"

Rails.application.routes.draw do
  devise_for :users, only: [:session, :password]
  root "projects#index"

  resources :synchronizes, only: [:index, :create]
  resources :columns, only: [:create, :show, :destroy]
  resources :rows, only: [:create, :show]
  resource :rows, only: [:destroy]

  resources :projects do
    resources :project_members
    resources :project_phases
    resource :project_status, only: [:show, :update]
    resources :product_backlogs, except: [:destroy]
    delete "/product_backlogs", to: "product_backlogs#destroy"
    resources :sprints do
      resources :work_performances
      resources :assignees
    end
  end

  namespace :api do
    resources :projects do
      resources :sprints do
        resources :work_performances, only: [:index]
        resources :tasks, only: [:index]
        resources :master_sprints, only: [:show]
      end
    end

    get "performances", to: "performances_table#index", as: :performances_data
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
  get "ajax/work_performances", to: "work_performances#show"

  resources :synchronizes, only: [:index, :create]
  resources :users, except: [:new, :create]
  resources :invite_users
end
