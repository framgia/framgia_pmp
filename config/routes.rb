Rails.application.routes.draw do
  devise_for :users, only: :session
  resources :sprints

  namespace :api do
    resources :sprints
  end
end
